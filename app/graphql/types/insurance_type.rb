module Types
  class InsuranceType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :agency_name, String, null: false
    field :kind, String, null: false
    field :total_cost, Float, null: false
    field :period, Int, null: false
    field :monthly_cost, Float, null: false
  end
end
