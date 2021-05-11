FactoryBot.define do
  factory :award do
    sequence(:title) { |n| "Award#{n}" }
    question
    user

    before(:create) do |award|
      award.image.attach(io: File.open(Rails.root.join("spec", "files", "star.jpg")), filename: 'star.jpg',
                         content_type: 'image/jpeg')
    end
  end
end
