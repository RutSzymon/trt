FactoryBot.define do
  factory :contactship do
    user factory: :agent
    contact factory: :operator
  end
end
