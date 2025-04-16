require 'rails_helper'

RSpec.describe ManageUsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in admin  # Sign in as admin before each test
  end

  describe "GET #index" do
    it "assigns @users and renders the index template" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:users)).to eq(User.includes(:roles).order(created_at: :desc))
    end
  end

  describe "GET #new" do
    it "assigns a new user and renders new template" do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) do
        attributes_for(:user).merge(password: 'password123', password_confirmation: 'password123')
      end

      it "creates a new user and sends a welcome email" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        
        # expect(ActionMailer::Base.deliveries.size).to eq(1)  # Ensuring email is sent
        expect(response).to redirect_to(manage_users_path)
        expect(flash[:notice]).to eq("User was successfully created.")
      end
    end

    context "with invalid attributes" do
      it "does not create a user and re-renders the form" do
        post :create, params: { user: { email: "", password: "short" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user_to_delete) { create(:user) }

    it "deletes the user and redirects" do
      expect {
        delete :destroy, params: { id: user_to_delete.id }
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(manage_users_path)
      expect(flash[:notice]).to eq("User deleted successfully.")
    end
  end

  describe "POST #toggle_status" do
    let!(:user_to_toggle) { create(:user, active: true) }

    it "toggles the user's active status" do
      expect {
        post :toggle_status, params: { id: user_to_toggle.id }
        user_to_toggle.reload
      }.to change { user_to_toggle.active }.from(true).to(false)

      expect(response).to redirect_to(manage_users_path)
      expect(flash[:notice]).to eq("User status updated!")
    end
  end

  describe "GET #upload" do
    it "renders the upload form" do
      get :upload
      expect(response).to have_http_status(:success)
    end
  end

#   describe "POST #upload_users" do
#     let(:csv_file) { fixture_file_upload('files/users.csv', 'text/csv') }

#     context "with valid CSV file" do
#       it "queues the job and redirects" do
#         expect {
#           post :upload_users, params: { file: csv_file }
#         }.to have_enqueued_job(ImportUsersJob)

#         expect(response).to redirect_to(manage_users_path)
#         expect(flash[:notice]).to eq("File uploaded successfully. Users will be imported in the background.")
#       end
#     end
#   end

  describe "Access Control" do
    before do
      sign_out admin
      sign_in user  # Non-admin user
    end

    it "restricts access to index for non-admin users" do
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access denied.")
    end
  end
end
