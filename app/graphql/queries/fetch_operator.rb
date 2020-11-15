module Queries
  class FetchOperator < Queries::BaseQuery
    type Types::OperatorType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Operator.find(id)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Operator does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end

    def authorized?(id:)
      operator = Operator.find(id)
      return true if context[:current_ability].can?(:read, operator)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
