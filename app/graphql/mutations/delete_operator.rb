module Mutations
  class DeleteOperator < Mutations::BaseMutation
    argument :id, ID, required: true

    field :operator, Types::OperatorType, null: false

    def resolve(id:)
      operator = Operator.find(id)

      begin
        operator.destroy

        { operator: operator }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Operator does not exist.')
      end
    end

    def authorized?(id:)
      operator = Operator.find(id)
      return true if context[:current_ability].can?(:destroy, operator)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
