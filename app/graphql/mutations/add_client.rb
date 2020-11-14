module Mutations
  class AddClient < Mutations::BaseMutation
    argument :params, Types::Input::ClientInputType, required: true

    field :client, Types::ClientType, null: false

    def resolve(params:)
      client_params = Hash params

      begin
        client = Client.create!(client_params)

        { client: client }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
