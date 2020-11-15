require 'rails_helper'

module Mutations
  RSpec.describe UpdateOperator, type: :request do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:agent_header) { { 'AUTHENTICATED_SCOPE' => 'agent', 'AUTHENTICATED_USERID' => agent.id } }
    let(:operator_header) { { 'AUTHENTICATED_SCOPE' => 'operator', 'AUTHENTICATED_USERID' => operator.id } }
    let!(:subject) { create(:operator, name: 'Stephen', surname: 'King', email: 's.king@mail.com') }

    describe '.resolve' do
      context 'operator' do
        it 'updates a operator' do
          post '/graphql', params: { query: query }, headers: operator_header

          expect(subject.reload).to have_attributes(id: subject.id, name: 'John', surname: 'Smith', email: 'j.smith@mail.com')
        end

        it 'returns a operator' do
          post '/graphql', params: { query: query }, headers: operator_header
          json = JSON.parse(response.body)
          data = json['data'].dig('updateOperator', 'operator')

          expect(data).to include('id' => subject.id.to_s, 'name' => 'John', 'surname' => 'Smith', 'email' => 'j.smith@mail.com')
        end
      end

      context 'agent' do
        it 'doesn\'t update a operator' do
          expect { post '/graphql', params: { query: query }, headers: agent_header }.to_not(change { subject })
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
          updateOperator(input: { id: #{subject.id}, params: { name: "John", surname: "Smith", email: "j.smith@mail.com"  }}) {
            operator {
              id
              name
              surname
              email
            }
          }
        }
      GQL
    end
  end
end
