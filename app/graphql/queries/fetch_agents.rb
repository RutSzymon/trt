module Queries
  class FetchAgents < Queries::BaseQuery
    type [Types::AgentType], null: false

    def resolve
      Agent.accessible_by(context[:current_ability]).order(created_at: :desc)
    end
  end
end
