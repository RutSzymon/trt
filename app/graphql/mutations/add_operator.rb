module Mutations
  class AddOperator < Mutations::BaseAddMutation
    argument :params, Types::Input::OperatorInputType, required: true

    field :operator, Types::OperatorType, null: false

    def resolve(params:)
      operator_params = Hash params

      begin
        operator = Operator.create!(operator_params)

        { operator: operator }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
