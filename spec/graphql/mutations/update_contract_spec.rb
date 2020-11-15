require 'rails_helper'

module Mutations
  RSpec.describe UpdateContract, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:contract) { create(:contract) }
    let(:client) { create(:client) }
    let(:insurance) { create(:insurance) }

    describe '.resolve' do
      context 'operator' do
        it 'updates a contract' do
          post '/graphql', params: { query: query }, headers: operator_header

          expect(contract.reload).to have_attributes(id: contract.id, client_id: client.id, agent_id: agent.id, insurance_id: insurance.id)
        end

        it 'returns a contract' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateContract', 'contract')

          expect(data).to include('id' => contract.id.to_s, 'clientId' => client.id, 'agentId' => agent.id, 'insuranceId' => insurance.id)
        end
      end

      context 'agent' do
        it 'updates a contract' do
          post '/graphql', params: { query: query }, headers: agent_header

          expect(contract.reload).to have_attributes(id: contract.id, client_id: client.id, agent_id: agent.id, insurance_id: insurance.id)
        end

        it 'returns a contract' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateContract', 'contract')

          expect(data).to include('id' => contract.id.to_s, 'clientId' => client.id, 'agentId' => agent.id, 'insuranceId' => insurance.id)
        end
      end
    end

    def query
      <<~GQL
        mutation {
          updateContract(input: { id: #{contract.id}, params: { clientId: #{client.id}, agentId: #{agent.id}, insuranceId: #{insurance.id}  }}) {
            contract {
              id
              clientId
              agentId
              insuranceId
            }
          }
        }
      GQL
    end
  end
end
