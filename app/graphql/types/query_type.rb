module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :fetch_agents, resolver: Queries::FetchAgents
    field :fetch_agent, resolver: Queries::FetchAgent

    field :fetch_clients, resolver: Queries::FetchClients
    field :fetch_client, resolver: Queries::FetchClient

    field :fetch_contracts, resolver: Queries::FetchContracts
    field :fetch_contract, resolver: Queries::FetchContract

    field :fetch_insurances, resolver: Queries::FetchInsurances
    field :fetch_insurance, resolver: Queries::FetchInsurance

    field :fetch_operators, resolver: Queries::FetchOperators
    field :fetch_operator, resolver: Queries::FetchOperator
  end
end
