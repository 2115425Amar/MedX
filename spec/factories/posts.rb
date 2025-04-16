FactoryBot.define do
  factory :post do
    description { "Test post description" }
    public { true }
    association :user

    trait :private do
      public { false }
    end
  end
end