require 'rails_helper'

module Queries
  RSpec.describe FetchInsurance, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:insurance) { create(:insurance, name: 'Lux', agency_name: 'King', kind: 'property', total_cost: 2400, period: 12) }

    describe '.resolve' do
      context 'operator' do
        it 'returns insurance for provided id' do
          post '/graphql', params: { query: query(id: insurance.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchInsurance']

          expect(data).to include('id' => insurance.id.to_s, 'name' => 'Lux', 'agencyName' => 'King', 'kind' => 'property',
                                  'totalCost' => 2400, 'period' => 12, 'monthlyCost' => 200)
        end
      end

      context 'agent' do
        it 'returns insurance for provided id' do
          post '/graphql', params: { query: query(id: insurance.id) }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchInsurance']

          expect(data).to include('id' => insurance.id.to_s, 'name' => 'Lux', 'agencyName' => 'King', 'kind' => 'property',
                                  'totalCost' => 2400, 'period' => 12, 'monthlyCost' => 200)
        end
      end
    end

    def query(id:)
      <<~GQL
        query {
          fetchInsurance(id: #{id}) {
            id
            name
            agencyName
            kind
            totalCost
            period
            monthlyCost
          }
        }
      GQL
    end
  end
end
