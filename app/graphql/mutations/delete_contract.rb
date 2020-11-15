module Mutations
  class DeleteContract < Mutations::BaseMutation
    argument :id, ID, required: true

    field :contract, Types::ContractType, null: false

    def resolve(id:)
      contract = Contract.find(id)

      begin
        contract.destroy

        { contract: contract }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Contract does not exist.')
      end
    end

    def authorized?(id:)
      contract = Contract.find(id)
      return true if context[:current_ability].can?(:destroy, contract)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
