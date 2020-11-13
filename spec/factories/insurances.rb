FactoryBot.define do
  factory :insurance do
    sequence(:name) { |n| "Name #{n}" }
    agency_name { 'Agency name' }
    kind { 'life' }
    total_cost { 1200 }
    period { 12 }
  end
end
