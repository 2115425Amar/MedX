require 'rails_helper'

# This is a test suite for the UsersController, which is responsible for handling user-related actions.
RSpec.describe UsersController, type: :controller do

  # Define a regular user and an admin user using FactoryBot.
  let(:user) { create(:user) }   
  let(:admin) { create(:user, :admin) }

  # Test cases for the #index action of the UsersController.
  describe 'GET #index' do
    # Context when a user is logged in.
    context 'when user is logged in' do
      # → Simulates a logged-in user using Devise’s sign_in helper.
      # → Before each test in this context, sign in the regular user.
      before do
        sign_in user
      end

      # Test to ensure the #index action returns a successful HTTP response.
      it 'returns a successful response' do
        get :index   # → Simulates an HTTP GET request to the index action.
        expect(response).to be_successful  # → Ensures that the request is successful (HTTP 200 OK)
      end

      # Test to ensure the @users  is assigned correctly.
      it 'assigns @users' do
        users = create_list(:user, 3) # Create a list of 3 additional users.
        get :index
        expect(assigns(:users)).to match_array([user] + users) # Expect @users to include the logged-in user and the created users.
      end
    end

    # Context: When the user is NOT logged in
    context 'when user is not logged in' do
      # Test to ensure the user is redirected to the login page.
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)  # → Ensures that unauthenticated users are redirected to the login page.
      end
    end

  end

  # 3. Testing the show Action
  describe 'GET #show' do
    # Context when a user is logged in.
    context 'when user is logged in' do
      # Before each test in this context, sign in the regular user.
      before { sign_in user }

      # Test 1: Ensuring a successful response
      it 'returns a successful response' do
        get :show, params: { id: user.id }
        expect(response).to be_successful
      end

      # Test to ensure the @user instance variable is assigned to the requested user.
      it 'assigns the requested user to @user' do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end

    # Context when no user is logged in.
    context 'when user is not logged in' do
      # Test to ensure the user is redirected to the login page.
      it 'redirects to login page' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
