module Queries
  class FetchContracts < Queries::BaseQuery
    type [Types::ContractType], null: false

    def resolve
      Contract.all.order(created_at: :desc)
    end
  end
end
