module Queries
  class FetchClient < Queries::BaseQuery
    type Types::ClientType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Client.find(id)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Client does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end

    def authorized?(id:)
      client = Client.find(id)
      return true if context[:current_ability].can?(:read, client)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
