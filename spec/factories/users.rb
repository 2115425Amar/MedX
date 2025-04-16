FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:phone_number) { |n| "1234567#{format('%03d', n)}" }  # Ensures 10 digits
    first_name { 'John' }
    last_name { 'Doe' }
    password { 'password123' }
    password_confirmation { 'password123' }
    trait :admin do            # trait :admin assigns the admin role after creating a user.
      after(:create) do |user|
        user.add_role(:admin)  # Assuming you're using rolify
      end
    end
  end
end
