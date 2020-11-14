module Queries
  class FetchClients < Queries::BaseQuery
    type [Types::ClientType], null: false

    def resolve
      Client.all.order(created_at: :desc)
    end
  end
end
