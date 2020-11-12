FactoryBot.define do
  trait :user do
    name { "Name" }
    surname { "Surname" }
    sequence(:email) { |n| "email#{n}@mail.com" }
  end

  factory :agent, traits: [:user]

  factory :operator, traits: [:user]
end
