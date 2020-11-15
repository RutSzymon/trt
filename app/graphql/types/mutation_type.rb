module Types
  class MutationType < Types::BaseObject
    field :add_client, mutation: Mutations::AddClient
    field :update_client, mutation: Mutations::UpdateClient
    field :delete_client, mutation: Mutations::DeleteClient

    field :add_contract, mutation: Mutations::AddContract
    field :update_contract, mutation: Mutations::UpdateContract
    field :delete_contract, mutation: Mutations::DeleteContract
  end
end
