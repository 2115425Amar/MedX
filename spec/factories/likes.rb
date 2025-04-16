FactoryBot.define do
  factory :like do
    association :user
    
    trait :for_post do
      association :likeable, factory: :post
      likeable_type { 'Post' }
    end

    trait :for_comment do
      association :likeable, factory: :comment
      likeable_type { 'Comment' }
    end

    # Default to liking posts if no trait is specified
    after(:build) do |like|
      if like.likeable.nil?
        like.likeable = create(:post)
        like.likeable_type = 'Post'
      end
    end
  end
end