module Mutations
  class UpdateOperator < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :params, Types::Input::OperatorInputType, required: true

    field :operator, Types::OperatorType, null: false

    def resolve(id:, params:)
      operator = Operator.find(id)
      operator_params = Hash params

      begin
        operator.update!(operator_params)

        { operator: operator }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Operator does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def authorized?(id:, params:)
      operator = Operator.find(id)
      return true if context[:current_ability].can?(:update, operator)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
