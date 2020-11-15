module Mutations
  class AddContract < Mutations::BaseAddMutation
    argument :params, Types::Input::ContractInputType, required: true

    field :contract, Types::ContractType, null: false

    def resolve(params:)
      contract_params = Hash params

      begin
        contract = Contract.create!(contract_params)

        { contract: contract }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
