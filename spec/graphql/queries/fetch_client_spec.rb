require 'rails_helper'

module Queries
  RSpec.describe FetchClient, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:client) { create(:client, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'returns client for provided id' do
          post '/graphql', params: { query: query(id: client.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchClient']

          expect(data).to include('id' => client.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end
      end

      context 'agent' do
        it 'returns client for provided id' do
          post '/graphql', params: { query: query(id: client.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchClient']

          expect(data).to include('id' => client.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end
      end
    end

    def query(id:)
      <<~GQL
        query {
          fetchClient(id: #{id}) {
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
