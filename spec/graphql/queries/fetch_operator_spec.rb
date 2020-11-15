require 'rails_helper'

module Queries
  RSpec.describe FetchOperator, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:operator) { create(:operator, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'returns operator for provided id' do
          post '/graphql', params: { query: query(id: operator.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchOperator']

          expect(data).to include('id' => operator.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end
      end

      context 'agent' do
        it 'returns operator for provided id if is agent\'s contact' do
          agent.contacts << operator
          post '/graphql', params: { query: query(id: operator.id) }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchOperator']

          expect(data).to include('id' => operator.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end

        it 'returns access denied' do
          post '/graphql', params: { query: query(id: operator.id) }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['errors'].first

          expect(data).to include('message' => 'Access denied')
        end
      end
    end

    def query(id:)
      <<~GQL
        query {
          fetchOperator(id: #{id}) {
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
