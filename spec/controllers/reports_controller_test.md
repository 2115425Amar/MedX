# Testing in the Ruby on Rails Social media Application

## Overview
This document explains how testing is implemented in the Ruby on Rails social media application. It covers the use of FactoryBot for test data creation and RSpec for controller tests, specifically for the `ReportsController`.

## FactoryBot Setup
FactoryBot is used to generate test data for users, posts, comments, and likes efficiently.

### Post Factory
```ruby
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
```
- Defines a `post` factory with a description and public visibility.
- Uses the `association :user` to associate a post with a user.
- Provides a `private` trait to create private posts.

### Like Factory
```ruby
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

    after(:build) do |like|
      if like.likeable.nil?
        like.likeable = create(:post)
        like.likeable_type = 'Post'
      end
    end
  end
end
```
- Defines a `like` factory associated with a user.
- Uses traits to specify whether a like is for a `post` or `comment`.
- Ensures a default association with a post if none is provided.

### Comment Factory
```ruby
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
```
- Defines a `comment` factory associated with a `user` and a `post`.
- The `with_likes` trait generates two associated likes per comment.

## How Traits Are Used
Traits in FactoryBot allow flexible test data creation. Here’s how they are utilized in tests:
- The `private` trait for `Post` enables testing private vs. public post visibility.
- The `for_post` and `for_comment` traits in `Like` ensure that likes are correctly associated with different entities.
- The `with_likes` trait in `Comment` helps generate realistic test data where comments have likes.

## ReportsController Testing
RSpec is used to test the `ReportsController`. It ensures the reports are generated correctly and that only admins can access them.

### Test Data Setup
```ruby
let(:admin) { create(:user, :admin) }
let(:user) { create(:user) }
let!(:users) { create_list(:user, 5) }
let!(:posts) { create_list(:post, 5, user: users.first) }
let!(:comments) { create_list(:comment, 5, user: users.first, post: posts.first) }
let!(:likes) { create_list(:like, 5, :for_post, user: users.first, likeable: posts.first) }
```
- Creates an `admin` user and a regular `user`.
- Generates a list of users, posts, comments, and likes to populate the database for testing.
- Uses traits (`:for_post`) to ensure likes are associated with posts.

### Authentication
Before each test, the admin is signed in:
```ruby
before { sign_in admin }
```

### Index Action Test
```ruby
describe 'GET #index' do
  it 'renders the index template' do
    get :index
    expect(response).to have_http_status(:success)
  end
end
```
- Ensures that the `index` action is accessible and returns a `200 OK` response.

### Download Report Tests
```ruby
describe 'GET #download_report' do
  context 'when downloading all_users report in CSV format' do
    it 'returns a valid CSV file' do
      get :download_report, params: { report_type: 'all_users', format: 'csv' }
      expect(response.header['Content-Type']).to include 'text/csv'
      expect(response.body).to include('ID,First Name,Last Name,Email,Posts Count,Comments Count,Likes Count')
    end
  end
```
- Requests the `all_users` report in CSV format.
- Verifies the response content type and CSV structure.

```ruby
  context 'when downloading all_users report in XLSX format' do
    it 'returns a valid XLSX file' do
      get :download_report, params: { report_type: 'all_users', format: 'xlsx' }
      expect(response.header['Content-Type']).to include 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    end
  end
```
- Ensures XLSX reports are generated correctly.

```ruby
  context 'when downloading with an invalid report type' do
    it 'redirects to reports index with an alert' do
      get :download_report, params: { report_type: 'invalid_report' }
      expect(response).to redirect_to(reports_path)
      expect(flash[:alert]).to eq('Invalid report type')
    end
  end
```
- Tests handling of invalid report types by verifying redirection and error messages.

### Authorization Tests
```ruby
describe 'Authorization' do
  before { sign_out admin }

  context 'when a non-admin user tries to access reports' do
    before { sign_in user }

    it 'redirects to root path with an alert' do
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied')
    end
  end
end
```
- Ensures that only admins can access reports.
- Tests redirection and error messages when unauthorized users attempt access.

## Conclusion
- FactoryBot simplifies test data generation.
- Traits enhance flexibility in test scenarios.
- RSpec verifies the behavior of `ReportsController`, ensuring reports are generated correctly.
- Tests cover authentication, authorization, and report generation in different formats.

