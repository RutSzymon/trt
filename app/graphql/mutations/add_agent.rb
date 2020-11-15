module Mutations
  class AddAgent < Mutations::BaseAddMutation
    argument :params, Types::Input::AgentInputType, required: true

    field :agent, Types::AgentType, null: false

    def resolve(params:)
      agent_params = Hash params

      begin
        agent = Agent.create!(agent_params)

        { agent: agent }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
