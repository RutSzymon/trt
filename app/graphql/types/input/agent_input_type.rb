module Types
  module Input
    class AgentInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :surname, String, required: true
      argument :email, String, required: true
    end
  end
end
