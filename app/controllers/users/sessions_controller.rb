class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user
      if user.active?
        if user.valid_password?(params[:user][:password])
          sign_in(resource_name, user)
          redirect_to after_sign_in_path_for(user)
        else
          flash[:alert] = "Invalid password."
          redirect_to new_user_session_path
        end
      else
        flash[:alert] = "Your account is deactivated. Please contact support."
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "No account found with this email."
      redirect_to new_user_session_path
    end
  end

  def destroy
    super
  end 
  
end
