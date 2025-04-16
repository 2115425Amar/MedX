require 'rails_helper'
require 'csv'
require 'caxlsx'

# Spec for ReportsController
describe ReportsController, type: :controller do
  # Setup test data
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:users) { create_list(:user, 5) }   # FactoryGirl create_list pass in multiple values
  let!(:posts) { create_list(:post, 5, user: users.first) }
  let!(:comments) { create_list(:comment, 5, user: users.first, post: posts.first) }
  let!(:likes) { create_list(:like, 5, :for_post, user: users.first, likeable: posts.first) }

  # Sign in as admin before each test
  before { sign_in admin }

  # Tests for the index action
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  # Tests for the download_report action
  describe 'GET #download_report' do
    # Test for downloading all_users report in CSV format
    context 'when downloading all_users report in CSV format' do
      it 'returns a valid CSV file' do
        get :download_report, params: { report_type: 'all_users', format: 'csv' }
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('ID,First Name,Last Name,Email,Posts Count,Comments Count,Likes Count')
      end
    end

    # Test for downloading all_users report in XLSX format
    context 'when downloading all_users report in XLSX format' do
      it 'returns a valid XLSX file' do
        get :download_report, params: { report_type: 'all_users', format: 'xlsx' }
        expect(response.header['Content-Type']).to include 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end

    # Test for downloading postwise report in CSV format
    context 'when downloading postwise report in CSV format' do
      it 'returns a valid CSV file' do
        get :download_report, params: { report_type: 'postwise', format: 'csv' }
        expect(response.header['Content-Type']).to include 'text/csv'
        expect(response.body).to include('Post ID,Description,Comments Count,Likes Count')
      end
    end

    # Test for invalid report type
    context 'when downloading with an invalid report type' do
      it 'redirects to reports index with an alert' do
        get :download_report, params: { report_type: 'invalid_report' }
        expect(response).to redirect_to(reports_path)
        expect(flash[:alert]).to eq('Invalid report type')
      end
    end
  end

  # Tests for authorization
  describe 'Authorization' do
    # Sign out admin before testing authorization
    before { sign_out admin }

    # Test for non-admin user trying to access reports
    context 'when a non-admin user tries to access reports' do
      before { sign_in user }

      it 'redirects to root path with an alert' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access denied')
      end
    end
    
  end
end
