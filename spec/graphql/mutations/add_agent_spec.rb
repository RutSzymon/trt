require 'rails_helper'

module Mutations
  RSpec.describe AddAgent, type: :request do
    let!(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }

    describe '.resolve' do
      context 'agent' do
        it 'creates a agent' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Agent.count }.by(1)
        end

        it 'returns a agent' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addAgent', 'agent')

          expect(data).to include('id' => be_present, 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end

      context 'agent' do
        it 'doesn\'t add a agent' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { Agent.count })
        end

        it 'returns access denied' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['errors'].first

          expect(data).to include('message' => 'Access denied')
        end
      end
    end

    def query
      <<~GQL
        mutation {
          addAgent(input: { params: { name: "John", surname: "Smith", email: "j.smith@mail.com"  }}) {
            agent {
              id
              name
              surname
              email
            }
          }
        }
      GQL
    end
  end
end
