module Types
  class MutationType < Types::BaseObject
    field :add_client, mutation: Mutations::AddClient
    field :update_client, mutation: Mutations::UpdateClient
    field :delete_client, mutation: Mutations::DeleteClient
  end
end
