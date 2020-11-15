require 'rails_helper'

module Queries
  RSpec.describe FetchContract, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:contract) { create(:contract) }

    describe '.resolve' do
      context 'operator' do
        it 'returns contract for provided id' do
          post '/graphql', params: { query: query(id: contract.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchContract']

          expect(data).to include('id' => contract.id.to_s, 'clientId' => contract.client_id, 'agentId' => contract.agent_id,
                                  'insuranceId' => contract.insurance_id)
        end
      end

      context 'agent' do
        it 'returns contract for provided id' do
          post '/graphql', params: { query: query(id: contract.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchContract']

          expect(data).to include('id' => contract.id.to_s, 'clientId' => contract.client_id, 'agentId' => contract.agent_id,
                                  'insuranceId' => contract.insurance_id)
        end
      end
    end

    def query(id:)
      <<~GQL
        query {
          fetchContract(id: #{id}) {
            id
            clientId
            agentId
            insuranceId
          }
        }
      GQL
    end
  end
end
