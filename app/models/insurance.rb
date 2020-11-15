class Insurance < ApplicationRecord
  KINDS = { life: 0, property: 1, health_care: 2 }.freeze

  enum kind: KINDS

  validates :agency_name, presence: true
  validates :name, presence: true
  validates :period, presence: true
  validates :total_cost, presence: true

  def monthly_cost
    (BigDecimal(total_cost) / period).round(2)
  end
end
