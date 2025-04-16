# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Check the referer to determine where to redirect
       # Safely check referer before calling include?
    if request.referer && request.referer.include?(post_path(@post))
        redirect_to post_path(@post), notice: "Comment added!"
      else
        redirect_to posts_path, notice: "Comment added!"
      end
    else
      flash[:alert] = "Comment could not be created"
      posts_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
