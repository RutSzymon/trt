require 'rails_helper'

module Mutations
  RSpec.describe DeleteInsurance, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:insurance) { create(:insurance, name: 'Lux', agency_name: 'King', kind: 'property', total_cost: 2400, period: 7) }

    describe '.resolve' do
      context 'operator' do
        it 'removes a insurance' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Insurance.count }.by(-1)
        end

        it 'returns a insurance' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('deleteInsurance', 'insurance')

          expect(data).to include('id' => insurance.id.to_s, 'name' => 'Lux', 'agencyName' => 'King', 'kind' => 'property',
                                  'totalCost' => 2400, 'period' => 7, 'monthlyCost' => 342.86)
        end
      end

      context 'agent' do
        it 'doesn\'t remove a insurance' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { Insurance.count })
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
          deleteInsurance(input: { id: #{insurance.id}}) {
            insurance {
              id
              name
              agencyName
              kind
              totalCost
              period
              monthlyCost
            }
          }
        }
      GQL
    end
  end
end
