FactoryBot.define do
  factory :user do
    name { "taro" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
