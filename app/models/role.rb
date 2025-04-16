class Role < ApplicationRecord
  # A role can belong to multiple users.
  has_and_belongs_to_many :users, :join_table => :users_roles  
  belongs_to :resource, :polymorphic => true, :optional => true
  # Roles can be associated with different resource types (polymorphic).
  
  validates :name, presence: true
  scopify
end
