# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user       # A post must belong to a user.
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy  #A post can have multiple comments.
  has_many :likes, as: :likeable, dependent: :destroy   # A post can be liked (Polymorphic Association).
  validates :description, presence: true
end



