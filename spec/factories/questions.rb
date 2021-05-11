FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  sequence :body do |n|
    "QuestionBody#{n}"
  end

  factory :question do
    title
    body
    user

    factory :question_with_answers do
      transient do
        answers_count {5}
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
