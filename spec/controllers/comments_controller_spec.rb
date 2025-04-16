require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) {create(:user)}
  let(:post_record) {create(:post, user: user)}

  before {sign_in user}

  describe 'Post #create' do
    context 'with valid parameters' do
      let(:valid_params) { { post_id: post_record.id, comment: { content: "This is a test comment" } } }

      it 'creates a new comment and redirects to posts_path' do
        expect {
          post :create, params: valid_params
        }.to change(Comment, :count).by(1)

        expect(flash[:notice]).to eq("Comment added!")
      end
    end
  end

end