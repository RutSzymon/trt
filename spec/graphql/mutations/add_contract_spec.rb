require 'rails_helper'

module Mutations
  RSpec.describe AddContract, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let(:client) { create(:client) }
    let(:insurance) { create(:insurance) }

    describe '.resolve' do
      context 'operator' do
        it 'creates a contract' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Contract.count }.by(1)
        end

        it 'returns a contract' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addContract', 'contract')

          expect(data).to include('id' => be_present, 'clientId' => client.id, 'agentId' => agent.id, 'insuranceId' => insurance.id)
        end
      end

      context 'agent' do
        it 'creates a contract' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to change { Contract.count }.by(1)
        end

        it 'returns a contract' do
          post '/graphql', params: { query: query }, headers: agent_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addContract', 'contract')

          expect(data).to include('id' => be_present, 'clientId' => client.id, 'agentId' => agent.id, 'insuranceId' => insurance.id)
        end
      end
    end

    def query
      <<~GQL
        mutation {
          addContract(input: { params: { clientId: #{client.id}, agentId: #{agent.id}, insuranceId: #{insurance.id}  }}) {
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
