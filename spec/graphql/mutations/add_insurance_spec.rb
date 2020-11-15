require 'rails_helper'

module Mutations
  RSpec.describe AddInsurance, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }

    describe '.resolve' do
      context 'operator' do
        it 'creates a insurance' do
          expect { post '/graphql', params: { query: query }, headers: operator_header }.to change { Insurance.count }.by(1)
        end

        it 'returns a insurance' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('addInsurance', 'insurance')

          expect(data).to include('id' => be_present, 'name' => 'Basic', 'agencyName' => 'Smith', 'kind' => 'life',
                                  'totalCost' => 1200, 'period' => 12)
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
          addInsurance(input: { params: { name: "Basic", agencyName: "Smith", kind: "life", totalCost: 1200, period: 12  }}) {
            insurance {
              id
              name
              agencyName
              kind
              totalCost
              period
            }
          }
        }
      GQL
    end
  end
end
