module Queries
  class FetchInsurances < Queries::BaseQuery
    type [Types::InsuranceType], null: false

    def resolve
      Insurance.accessible_by(context[:current_ability]).order(created_at: :desc)
    end
  end
end
