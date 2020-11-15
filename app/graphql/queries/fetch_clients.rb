module Queries
  class FetchClients < Queries::BaseQuery
    type [Types::ClientType], null: false

    def resolve
      Client.accessible_by(context[:current_ability]).order(created_at: :desc)
    end
  end
end
