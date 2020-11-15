require 'rails_helper'

module Queries
  RSpec.describe FetchOperators, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:operators) { create_list(:operator, 2) }

    describe '.resolve' do
      context 'operator' do
        it 'returns all operators' do
          post '/graphql', params: { query: query }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchOperators']

          expect(data).to match_array [
            hash_including('id' => operator.id.to_s, 'name' => operator.name, 'surname' => operator.surname, 'email' => operator.email),
            hash_including('id' => operators[0].id.to_s, 'name' => operators[0].name, 'surname' => operators[0].surname, 'email' => operators[0].email),
            hash_including('id' => operators[1].id.to_s, 'name' => operators[1].name, 'surname' => operators[1].surname, 'email' => operators[1].email)
          ]
        end
      end

      context 'agent' do
        it 'returns only operators from agent contacts' do
          agent.contacts << operators[0]
          post '/graphql', params: { query: query }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchOperators']

          expect(data).to match_array [
            hash_including('id' => operators[0].id.to_s, 'name' => operators[0].name, 'surname' => operators[0].surname, 'email' => operators[0].email)
          ]
        end
      end
    end

    def query
      <<~GQL
        query {
          fetchOperators {
            id
            name
            surname
            email
          }
        }
      GQL
    end
  end
end
