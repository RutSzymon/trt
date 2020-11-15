module Mutations
  class UpdateContract < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :params, Types::Input::ContractInputType, required: true

    field :contract, Types::ContractType, null: false

    def resolve(id:, params:)
      contract = Contract.find(id)
      contract_params = Hash params

      begin
        contract.update!(contract_params)

        { contract: contract }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Contract does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def authorized?(id:, params:)
      contract = Contract.find(id)
      return true if context[:current_ability].can?(:update, contract)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
