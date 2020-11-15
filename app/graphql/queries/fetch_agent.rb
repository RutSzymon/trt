module Queries
  class FetchAgent < Queries::BaseQuery
    type Types::AgentType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Agent.find(id)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Agent does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end

    def authorized?(id:)
      agent = Agent.find(id)
      return true if context[:current_ability].can?(:read, agent)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
