require 'rails_helper'

module Queries
  RSpec.describe FetchContracts, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:contracts) { create_list(:contract, 2) }

    describe '.resolve' do
      context 'operator' do
        it 'returns all contracts' do
          post '/graphql', params: { query: query }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchContracts']

          expect(data).to match_array [
            hash_including('id' => contracts[0].id.to_s, 'clientId' => contracts[0].client_id, 'agentId' => contracts[0].agent_id,
                           'insuranceId' => contracts[0].insurance_id),
            hash_including('id' => contracts[1].id.to_s, 'clientId' => contracts[1].client_id, 'agentId' => contracts[1].agent_id,
                           'insuranceId' => contracts[1].insurance_id)
          ]
        end
      end

      context 'agent' do
        it 'returns all contracts' do
          post '/graphql', params: { query: query }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchContracts']

          expect(data).to match_array [
            hash_including('id' => contracts[0].id.to_s, 'clientId' => contracts[0].client_id, 'agentId' => contracts[0].agent_id,
                           'insuranceId' => contracts[0].insurance_id),
            hash_including('id' => contracts[1].id.to_s, 'clientId' => contracts[1].client_id, 'agentId' => contracts[1].agent_id,
                           'insuranceId' => contracts[1].insurance_id)
          ]
        end
      end
    end

    def query
      <<~GQL
        query {
          fetchContracts {
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
