class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @likeable = find_likeable
    like = @likeable.likes.find_by(user: current_user)

    if like
      like.destroy
    else
      @likeable.likes.create(user: current_user)
    end
  end

  private

  def find_likeable
    if params[:post_id]
      Post.find(params[:post_id])
    elsif params[:comment_id]
      Comment.find(params[:comment_id])
    end
  end
  
end
