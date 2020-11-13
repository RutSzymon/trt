FactoryBot.define do
  factory :client do
    name { "Name" }
    surname { "Surname" }
    sequence(:email) { |n| "email#{n}@mail.com" }
  end
end
