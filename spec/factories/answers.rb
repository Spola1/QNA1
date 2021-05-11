FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer#{n}" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
