require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  # Define test users and posts for the test cases
  let(:user) { create(:user) }   # user → The main test user.
  let(:other_user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }
  let(:private_post) { create(:post, :private, user: user) }

  # Ensures that the user is signed in before each test, using Devise's sign_in helper.
  before { sign_in user }

  # 2. Testing index Action (GET #index)
  # Test that the index action returns a successful response
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
  # Test that a public post can be viewed successfully
    context 'when post is public' do
      it 'returns a successful response' do
        get :show, params: { id: post_obj.id }
        expect(response).to be_successful
      end
    end

    context 'when post is private and user is owner' do
      # Purpose: Ensure different users can (or cannot) access posts based on their visibility.
      # Test that the owner of a private post can view it successfully
      it 'returns a successful response' do
        get :show, params: { id: private_post.id }
        expect(response).to be_successful
      end
    end

    context 'when post is private and user is not owner' do
      # Sign in a different user before testing
      before { sign_in other_user }

      # Test that a non-owner cannot view a private post and is redirected
      it 'redirects to posts index' do
        get :show, params: { id: private_post.id }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      # Test that a post is created successfully with valid attributes
      it 'creates a new post' do
        expect {
          post :create, params: { post: attributes_for(:post) }
        }.to change(Post, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      # Test that a post is not created with invalid attributes
      it 'does not create a new post' do
        expect {
          post :create, params: { post: attributes_for(:post, description: '') }
        }.not_to change(Post, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'when user is owner' do
      # Purpose: Ensure a user can update their own posts.
      it 'updates the post' do
        patch :update, params: { id: post_obj.id, post: { description: 'Updated' } }
        expect(post_obj.reload.description).to eq('Updated')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is owner' do
      before { sign_in user }

      # Test that the owner can delete their post successfully
      it 'deletes the post' do
        post_to_delete = create(:post, user: user)
        expect {
          delete :destroy, params: { id: post_to_delete.id }
        }.to change(Post, :count).by(-1)
      end
    end

    # Non-Owner Cannot Delete Post
    context 'when user is not owner' do
      before do
        sign_in other_user
        @post = create(:post, user: user)  # Create the post before testing deletion
      end

      # Test that a non-owner cannot delete a post
      it 'does not delete the post' do
        expect {
          delete :destroy, params: { id: @post.id }
        }.not_to change(Post, :count)
      end
    end
  end
end
