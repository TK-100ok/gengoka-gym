FactoryBot.define do
  factory :target do
    sequence(:name) { |n| "target#{n}" }
  end
end
