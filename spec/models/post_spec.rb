require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments).order(created_at: :desc).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
  end
end
