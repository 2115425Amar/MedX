# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :user      # Each comment belongs to a user.
  belongs_to :post      # Each comment belongs to a post.
  has_many :likes, as: :likeable, dependent: :destroy   # A comment can be liked (Polymorphic Association).

  validates :content, presence: true
end
