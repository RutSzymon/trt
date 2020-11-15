require 'rails_helper'

module Queries
  RSpec.describe FetchClients, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { "AUTHENTICATED_SCOPE" => "agent", "AUTHENTICATED_USERID" => agent.id } }
    let(:operator_header) { { "AUTHENTICATED_SCOPE" => "operator", "AUTHENTICATED_USERID" => operator.id } }
    let!(:clients) { create_list(:client, 2) }

    describe '.resolve' do
      context 'operator' do
        it 'returns all clients' do
          post '/graphql', params: { query: query }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchClients']

          expect(data).to match_array [
            hash_including('id' => "#{clients[0].id}", 'name' => clients[0].name, 'surname' => clients[0].surname, 'email' => clients[0].email),
            hash_including('id' => "#{clients[1].id}", 'name' => clients[1].name, 'surname' => clients[1].surname, 'email' => clients[1].email)
          ]
        end
      end

      context 'agent' do
        it 'returns all clients' do
          post '/graphql', params: { query: query }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchClients']

          expect(data).to match_array [
            hash_including('id' => "#{clients[0].id}", 'name' => clients[0].name, 'surname' => clients[0].surname, 'email' => clients[0].email),
            hash_including('id' => "#{clients[1].id}", 'name' => clients[1].name, 'surname' => clients[1].surname, 'email' => clients[1].email)
          ]
        end
      end
    end

    def query
      <<~GQL
        query {
          fetchClients {
            id
            name
            surname
            email
          }
        }
      GQL
    end
  end
end
