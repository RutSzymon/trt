require 'rails_helper'

module Queries
  RSpec.describe FetchInsurances, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:insurances) { create_list(:insurance, 2) }

    describe '.resolve' do
      context 'operator' do
        it 'returns all insurances' do
          post '/graphql', params: { query: query }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchInsurances']

          expect(data).to match_array [
            hash_including('id' => insurances[0].id.to_s, 'name' => insurances[0].name, 'agencyName' => insurances[0].agency_name,
                           'kind' => insurances[0].kind, 'totalCost' => insurances[1].total_cost, 'period' => insurances[1].period,
                           'monthlyCost' => insurances[0].monthly_cost),
            hash_including('id' => insurances[1].id.to_s, 'name' => insurances[1].name, 'agencyName' => insurances[1].agency_name,
                           'kind' => insurances[1].kind, 'totalCost' => insurances[1].total_cost, 'period' => insurances[1].period,
                           'monthlyCost' => insurances[0].monthly_cost)
          ]
        end
      end

      context 'agent' do
        it 'returns all insurances' do
          post '/graphql', params: { query: query }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchInsurances']

          expect(data).to match_array [
            hash_including('id' => insurances[0].id.to_s, 'name' => insurances[0].name, 'agencyName' => insurances[0].agency_name,
                           'kind' => insurances[0].kind, 'totalCost' => insurances[1].total_cost, 'period' => insurances[1].period,
                           'monthlyCost' => insurances[0].monthly_cost),
            hash_including('id' => insurances[1].id.to_s, 'name' => insurances[1].name, 'agencyName' => insurances[1].agency_name,
                           'kind' => insurances[1].kind, 'totalCost' => insurances[1].total_cost, 'period' => insurances[1].period,
                           'monthlyCost' => insurances[0].monthly_cost)
          ]
        end
      end
    end

    def query
      <<~GQL
        query {
          fetchInsurances {
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
