require 'rails_helper'

module Queries
  RSpec.describe FetchAgent, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    subject { create(:agent, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'returns operator for provided id' do
          post '/graphql', params: { query: query(id: subject.id) }, headers: operator_header

          json = JSON.parse(response.body)
          data = json['data']['fetchAgent']

          expect(data).to include('id' => subject.id.to_s, 'name' => 'Stephen', 'surname' => 'King', 'email' => 's.king@mail.com')
        end
      end

      context 'agent' do
        it 'returns himself' do
          post '/graphql', params: { query: query(id: agent.id) }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['data']['fetchAgent']

          expect(data).to include('id' => agent.id.to_s, 'name' => agent.name, 'surname' => agent.surname, 'email' => agent.email)
        end

        it 'returns access denied to other agents' do
          post '/graphql', params: { query: query(id: subject.id) }, headers: agent_header

          json = JSON.parse(response.body)
          data = json['errors'].first

          expect(data).to include('message' => 'Access denied')
        end
      end
    end

    def query(id:)
      <<~GQL
        query {
          fetchAgent(id: #{id}) {
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
