class Users::SessionsController < Devise::SessionsController
  # customizations, if any, go here
  def new
    super
  end

    def create
      # Find the user by email
      user = User.find_by(email: params[:user][:email])

      if user && user.active?
        # If the user is active and the password is valid, proceed with the login
        super
      else
        # If the user is not active or the password is invalid, show an error message
        flash[:alert] = "Your account is not active or the credentials are invalid."
        redirect_to new_user_session_path
      end
    end

    def destroy
      super
    end
end
