FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment#{n}" }
    user
    commentable factory: :question
  end
end
