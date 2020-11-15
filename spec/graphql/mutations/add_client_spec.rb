require 'rails_helper'

module Mutations
  RSpec.describe AddClient, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }

    describe '.resolve' do
      context 'operator' do
        it 'creates a client' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Client.count }.by(1)
        end

        it 'returns a client' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addClient', 'client')

          expect(data).to include('id' => be_present, 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end

      context 'agent' do
        it 'creates a client' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to change { Client.count }.by(1)
        end

        it 'returns a client' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addClient', 'client')

          expect(data).to include('id' => be_present, 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end
    end

    def query
      <<~GQL
        mutation {
          addClient(input: { params: { name: "John", surname: "Smith", email: "j.smith@mail.com"  }}) {
            client {
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
