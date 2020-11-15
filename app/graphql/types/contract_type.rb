module Types
  class ContractType < Types::BaseObject
    field :id, ID, null: false
    field :clientId, Int, null: false
    field :agentId, Int, null: false
    field :insuranceId, Int, null: false
  end
end
