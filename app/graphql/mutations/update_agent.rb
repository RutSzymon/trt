module Mutations
  class UpdateAgent < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :params, Types::Input::AgentInputType, required: true

    field :agent, Types::AgentType, null: false

    def resolve(id:, params:)
      agent = Agent.find(id)
      agent_params = Hash params

      begin
        agent.update!(agent_params)

        { agent: agent }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Agent does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def authorized?(id:, params:)
      agent = Agent.find(id)
      return true if context[:current_ability].can?(:update, agent)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
