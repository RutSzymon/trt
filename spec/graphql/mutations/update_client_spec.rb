require 'rails_helper'

module Mutations
  RSpec.describe UpdateClient, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { "AUTHENTICATED_SCOPE" => "agent", "AUTHENTICATED_USERID" => agent.id } }
    let(:operator_header) { { "AUTHENTICATED_SCOPE" => "operator", "AUTHENTICATED_USERID" => operator.id } }
    let!(:client) { create(:client, name: "Stephen", surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'updates a client' do
          post '/graphql', params: { query: query }, headers: operator_header

          expect(client.reload).to have_attributes(id: client.id, name: 'John', surname: 'Smith', email: 'j.smith@mail.com')
        end

        it 'returns a client' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateClient', 'client')

          expect(data).to include('id' => "#{client.id}", 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end

      context 'agent' do
        it 'updates a client' do
          post '/graphql', params: { query: query }, headers: agent_header

          expect(client.reload).to have_attributes(id: client.id, name: 'John', surname: 'Smith', email: 'j.smith@mail.com')
        end

        it 'returns a client' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateClient', 'client')

          expect(data).to include('id' => "#{client.id}", 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end
    end

    def query
      <<~GQL
        mutation {
          updateClient(input: { id: #{client.id}, params: { name: "John", surname: "Smith", email: "j.smith@mail.com"  }}) {
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
