class Like < ApplicationRecord
  belongs_to :user    # Each like belongs to a user.
  belongs_to :likeable, polymorphic: true    # Polymorphic Association.

  # validates :user_id, uniqueness: { scope: [:likeable_type, :likeable_id] }    # A user can like a likeable object only once.
end




# What is Polymorphic Association?
# A polymorphic association means a record can belong to multiple models.

# In the likes table:
# likeable_type = "Post" → If the like is on a post.
# likeable_type = "Comment" → If the like is on a comment.