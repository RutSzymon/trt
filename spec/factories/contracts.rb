FactoryBot.define do
  factory :contract do
    client factory: :client
    agent factory: :agent
    insurance factory: :insurance
  end
end
