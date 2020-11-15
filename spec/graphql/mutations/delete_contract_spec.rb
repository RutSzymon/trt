require 'rails_helper'

module Mutations
  RSpec.describe DeleteContract, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:contract) { create(:contract) }

    describe '.resolve' do
      context 'operator' do
        it 'removes a contract' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Contract.count }.by(-1)
        end

        it 'returns a contract' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('deleteContract', 'contract')

          expect(data).to include('id' => contract.id.to_s, 'clientId' => be_present, 'agentId' => be_present, 'insuranceId' => be_present)
        end
      end

      context 'agent' do
        it 'doesn\'t remove a contract' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { Contract.count })
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
          deleteContract(input: { id: #{contract.id}}) {
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
