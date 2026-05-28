FactoryBot.define do
  factory :training do
    theme { "面接" }
    explanation { "これは面接についての説明です" }

    association :user
    association :target
  end
end
