module Queries
  class FetchOperators < Queries::BaseQuery
    type [Types::OperatorType], null: false

    def resolve
      Operator.accessible_by(context[:current_ability]).order(created_at: :desc)
    end
  end
end
