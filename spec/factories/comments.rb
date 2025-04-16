FactoryBot.define do
  factory :comment do
    content { "Test comment content" }
    association :user
    association :post

    trait :with_likes do
      after(:create) do |comment|
        create_list(:like, 2, likeable: comment)
      end
    end
  end
end