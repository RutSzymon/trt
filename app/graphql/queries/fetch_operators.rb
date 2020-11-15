module Queries
  class FetchOperators < Queries::BaseQuery
    type [Types::OperatorType], null: false

    def resolve
      Operator.accessible_by(context[:current_ability]).order(contacts_count: :desc)
    end
  end
end
