# /home/hp/Desktop/auth2/devise_auth/app/models/user.rb
class User < ApplicationRecord
  rolify
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits"}
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :posts, dependent: :destroy       #  A user can create multiple posts.
  has_many :likes, dependent: :destroy       #  A user can like multiple posts or comments.
  has_many :comments, dependent: :destroy    #  A user can comment on multiple posts.

  after_create :assign_default_role
  after_create :upload_avatar

  def assign_default_role
    self.add_role(:user) if self.roles.blank?  # Assign "user" role by default
  end

  # Avatar Upload (Cloudinary)
  attr_accessor :avatar
  def avatar_url
    # If an avatar is uploaded, fetch it from Cloudinary.
    if avatar_public_id.present?
      Cloudinary::Utils.cloudinary_url(avatar_public_id, width: 150, height: 150, crop: :fill)
    else
      # asset_path("imageavatar.jpg") # Default image if no avatar is uploaded
      ActionController::Base.helpers.asset_path("imageavatar.jpg")
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def active?
    active
  end

  def admin?
    has_role?(:admin)
  end

private

  def upload_avatar
    return unless avatar.present? # Ensure avatar is present

    # Rails.logger.info "Uploading avatar..."
    response = Cloudinary::Uploader.upload(avatar, folder: "avatars")
    self.update_column(:avatar_public_id, response["public_id"])  # Save public ID in DB

    Rails.logger.info "Avatar uploaded successfully: #{response["public_id"]}"
  rescue Cloudinary::Error => e
    Rails.logger.error "Failed to upload avatar: #{e.message}"
  end
end
