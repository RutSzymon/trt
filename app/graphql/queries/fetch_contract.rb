module Queries
  class FetchContract < Queries::BaseQuery
    type Types::ContractType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Contract.find(id)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Contract does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end

    def authorized?(id:)
      contract = Contract.find(id)
      return true if context[:current_ability].can?(:read, contract)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
