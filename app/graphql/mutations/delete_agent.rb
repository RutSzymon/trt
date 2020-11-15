module Mutations
  class DeleteAgent < Mutations::BaseMutation
    argument :id, ID, required: true

    field :agent, Types::AgentType, null: false

    def resolve(id:)
      agent = Agent.find(id)

      begin
        agent.destroy

        { agent: agent }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Agent does not exist.')
      end
    end

    def authorized?(id:)
      agent = Agent.find(id)
      return true if context[:current_ability].can?(:destroy, agent)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
