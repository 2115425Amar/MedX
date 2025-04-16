class ManageUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.includes(:roles).order(created_at: :desc)
    @users = @users.page(params[:page]).per(10) if params[:page].present?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Send welcome email
      UserMailer.welcome_email(@user).deliver_later
      redirect_to manage_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      redirect_to manage_users_path, notice: "User deleted successfully."
    else
      redirect_to manage_users_path, alert: "Failed to delete user."
    end
  end

  def toggle_status
    user = User.find(params[:id])
    user.update(active: !user.active?)

    redirect_to manage_users_path, notice: "User status updated!"
  end

  def upload
  end

  def upload_users
    if params[:file].present? && params[:file].content_type == 'text/csv'
      ImportUsersJob.perform_later(params[:file].path)
      redirect_to manage_users_path, notice: 'File uploaded successfully. Users will be imported in the background.'
    else
      redirect_to upload_manage_users_path, alert: 'Please upload a valid CSV file.'
    end
  end

  private

  def require_admin
    unless current_user.has_role?(:admin)
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end
end
