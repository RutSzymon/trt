module Mutations
  class DeleteClient < Mutations::BaseMutation
    argument :id, ID, required: true

    field :client, Types::ClientType, null: false

    def client
      @client ||= Client.find(id)
    end

    def resolve(id:)
      client = Client.find(id)

      begin
        client.destroy

        { client: client }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Client does not exist.')
      end
    end

    def authorized?(id:)
      @client = Client.find(id)
      if !context[:current_ability].can?(:destroy, client)
        raise GraphQL::ExecutionError, "Access denied"
      else
        true
      end
    end
  end
end
