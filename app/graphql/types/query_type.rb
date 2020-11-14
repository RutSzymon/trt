module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :fetch_clients, resolver: Queries::FetchClients
    field :fetch_client, resolver: Queries::FetchClient
  end
end
