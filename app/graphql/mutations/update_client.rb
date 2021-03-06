module Mutations
  class UpdateClient < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :params, Types::Input::ClientInputType, required: true

    field :client, Types::ClientType, null: false

    def resolve(id:, params:)
      client = Client.find(id)
      client_params = Hash params

      begin
        client.update!(client_params)

        { client: client }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Client does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def authorized?(id:, params:)
      client = Client.find(id)
      return true if context[:current_ability].can?(:update, client)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
