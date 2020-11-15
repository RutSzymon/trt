require 'rails_helper'

module Mutations
  RSpec.describe UpdateAgent, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:subject) { create(:agent, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'updates a agent' do
          post '/graphql', params: { query: query }, headers: operator_header

          expect(subject.reload).to have_attributes(id: subject.id, name: 'John', surname: 'Smith', email: 'j.smith@mail.com')
        end

        it 'returns a agent' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateAgent', 'agent')

          expect(data).to include('id' => subject.id.to_s, 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end

      context 'agent' do
        it 'doesn\'t update a agent' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { subject })
        end

        it 'returns access denied' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['errors'].first

          expect(data).to include('message' => 'Access denied')
        end

        it 'updates himself' do
          post '/graphql', params: { query: query(id: agent.id) }, headers: agent_header

          expect(agent.reload).to have_attributes(id: agent.id, name: 'John', surname: 'Smith', email: 'j.smith@mail.com')
        end
      end
    end

    def query(id: subject.id)
      <<~GQL
        mutation {
          updateAgent(input: { id: #{id}, params: { name: "John", surname: "Smith", email: "j.smith@mail.com"  }}) {
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
