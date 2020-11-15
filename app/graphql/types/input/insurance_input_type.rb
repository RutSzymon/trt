module Types
  module Input
    class InsuranceInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :agency_name, String, required: true
      argument :kind, String, required: true
      argument :total_cost, Float, required: true
      argument :period, Int, required: true
    end
  end
end
