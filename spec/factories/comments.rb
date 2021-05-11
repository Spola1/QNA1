FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n}" }
    user
    votable factory: :question
  end
end
