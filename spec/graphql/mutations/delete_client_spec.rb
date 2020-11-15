require 'rails_helper'

module Mutations
  RSpec.describe DeleteClient, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { "AUTHENTICATED_SCOPE" => "agent", "AUTHENTICATED_USERID" => agent.id } }
    let(:operator_header) { { "AUTHENTICATED_SCOPE" => "operator", "AUTHENTICATED_USERID" => operator.id } }
    let!(:client) { create(:client, name: "William", surname: 'Penn', email: 'w.penn@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'removes a client' do
          expect{ post '/graphql', params: { query: query }, headers: operator_header }.to change { Client.count }.by(-1)
        end

        it 'returns a client' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('deleteClient', 'client')

          expect(data).to include('id' => "#{client.id}", 'name' => 'William', 'surname' => 'Penn', 'email' => 'w.penn@mail.com')
        end
      end

      context 'agent' do
        it 'doesn\'t remove a client' do
          expect{ post '/graphql', params: { query: query }, headers: agent_header }.to_not change { Client.count }
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
          deleteClient(input: { id: #{client.id}}) {
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
