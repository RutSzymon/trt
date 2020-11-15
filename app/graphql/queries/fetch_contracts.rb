module Queries
  class FetchContracts < Queries::BaseQuery
    type [Types::ContractType], null: false

    def resolve
      Contract.accessible_by(context[:current_ability]).order(created_at: :desc)
    end
  end
end
