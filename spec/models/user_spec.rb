require 'rails_helper'

# Spec for the User model
RSpec.describe User, type: :model do
  # Validation tests to ensure the presence, uniqueness, and format of attributes
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_uniqueness_of(:phone_number) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    # Validates email format (valid email)
    it { should allow_value('test@example.com').for(:email) }
    # Validates email format (invalid email)
    it { should_not allow_value('invalid-email').for(:email) }

    # Validates phone_number format (valid phone number)
    it { should allow_value('1234567811').for(:phone_number) }
    # Validates phone_number format (invalid phone number)
    it { should_not allow_value('12345').for(:phone_number) }
  end

  # Association tests to ensure relationships between models
  describe 'associations' do
    # User has many posts, and they are destroyed when the user is deleted
    it { should have_many(:posts).dependent(:destroy) }
    # User has many likes, and they are destroyed when the user is deleted
    it { should have_many(:likes).dependent(:destroy) }
    # User has many comments, and they are destroyed when the user is deleted
    it { should have_many(:comments).dependent(:destroy) }
  end

  # To ensure that a User is assigned the correct default role.
  describe 'roles' do
    let(:user) { create(:user) }

    # Ensures a default role is assigned to the user after creation
    it 'assigns default role after creation' do
      expect(user.has_role?(:user)).to be_truthy
    end
  end

  # Tests for the #avatar_url method
  describe '#avatar_url' do
    let(:user) { create(:user, avatar_public_id: 'sample_public_id') }

    # Returns the Cloudinary URL if the user has uploaded an avatar
    it 'returns Cloudinary URL if avatar is uploaded' do
      expect(user.avatar_url).to include('sample_public_id')
    end

    # To check if the avatar_url method correctly returns the user’s profile picture URL.
    it 'returns default avatar if no avatar is uploaded' do
      user.avatar_public_id = nil
      # Matches the default avatar file name pattern
      expect(user.avatar_url).to match(/imageavatar.*\.jpg/)
    end
  end

  # Tests for the #name method
  describe '#name' do
    let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

    # To check if the #name method correctly returns the full name.
    it 'returns full name' do
      expect(user.name).to eq('John Doe')
    end
  end

    # To check if the admin? method correctly identifies admin users.  describe '#admin?' do
    # Returns true if the user has an admin role
    it 'returns true if user has admin role' do
      admin = create(:user, :admin)
      expect(admin.admin?).to be true
    end

    # Returns false if the user does not have an admin role
    it 'returns false if user does not have admin role' do
      user = create(:user)
      expect(user.admin?).to be false
    end
  end

  # To ensure assign_default_role is called when a user is created.
  describe 'callbacks' do
    let(:user) { build(:user) }

    # Ensures the assign_default_role method is called after the user is created
    it 'calls assign_default_role after create' do
      expect(user).to receive(:assign_default_role)
      user.run_callbacks(:create)
    end
  end
  
end