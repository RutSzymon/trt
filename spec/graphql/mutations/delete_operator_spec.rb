require 'rails_helper'

module Mutations
  RSpec.describe DeleteOperator, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:operator) { create(:operator, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'removes a operator' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Operator.count }.by(-1)
        end

        it 'returns a operator' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('deleteOperator', 'operator')

          expect(data).to include('id' => operator.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end
      end

      context 'agent' do
        it 'doesn\'t remove a operator' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { Operator.count })
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
          deleteOperator(input: { id: #{operator.id}}) {
            operator {
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
