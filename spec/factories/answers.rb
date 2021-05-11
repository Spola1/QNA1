FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer#{n}" }
    question
    user

    trait :invalid do
      body { nil }
    end

    factory :answer_with_file do
      after(:create) do |answer|
        answer.files.attach(io: File.open(Rails.root.join("spec", "files", "star.jpg")), filename: 'star.jpg',
                            content_type: 'image/jpeg')
      end
    end
  end
end
