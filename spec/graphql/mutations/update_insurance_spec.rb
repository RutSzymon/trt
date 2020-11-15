require 'rails_helper'

module Mutations
  RSpec.describe UpdateInsurance, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:insurance) { create(:insurance, name: 'Lux', agency_name: 'King', kind: 'property', total_cost: 2400, period: 6) }

    describe '.resolve' do
      context 'operator' do
        it 'updates a insurance' do
          post '/graphql', params: { query: query }, headers: operator_header

          expect(insurance.reload).to have_attributes(id: insurance.id, name: 'Basic', agency_name: 'Smith', kind: 'life',
                                                      total_cost: 1200, period: 12, monthly_cost: 100)
        end

        it 'returns a insurance' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateInsurance', 'insurance')

          expect(data).to include('id' => insurance.id.to_s, 'name' => 'Basic', 'agencyName' => 'Smith', 'kind' => 'life',
                                  'totalCost' => 1200, 'period' => 12, 'monthlyCost' => 100)
        end
      end

      context 'agent' do
        it 'doesn\'t add a agent' do
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
          updateInsurance(input: { id: #{insurance.id}, params: { name: "Basic", agencyName: "Smith", kind: "life", totalCost: 1200, period: 12  }}) {
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
