module Types
  module Input
    class ContractInputType < Types::BaseInputObject
      argument :clientId, Int, required: true
      argument :agentId, Int, required: true
      argument :insuranceId, Int, required: true
    end
  end
end
