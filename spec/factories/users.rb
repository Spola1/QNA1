FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    factory :user_with_awards do
      transient do
        awards_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:award, evaluator.awards_count, user: user)
      end
    end
  end
end
