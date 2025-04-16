# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, only: %i[show edit update destroy]

  def index
    @users = User.all  # Load all users for the sidebar

    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user
        @posts = @user.posts.includes(:comments).order(created_at: :desc)
      else
        redirect_to posts_path, alert: "User not found."
      end
    else
      if current_user.has_role?(:admin)
        @posts = Post.includes(:user, :comments).order(created_at: :desc)
      else
        @posts = Post.where(public: true).or(Post.where(user: current_user)).order(created_at: :desc)
      end
    end
  end

  def show
    @post = Post.includes(:comments).find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: "Post not found."
    end
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: "You can only edit your own posts."
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created successfully."
    else
      redirect_to posts_path, alert: "post content can't be blank"
    end
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "Post updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if current_user.has_role?(:admin) || @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: "Post was successfully deleted."
    else
      redirect_to posts_path, alert: "You are not authorized to delete this post."
    end
  end


  private

  def set_post
    # @post = current_user.posts.find_by(id: params[:id])
    @post = Post.find_by(id: params[:id]) # Allow admin to fetch any post
    # puts "Post: #{@post.inspect}" # Debugging statement
    redirect_to posts_path, alert: "Post not found." if @post.nil?
  end

  def post_params
    params.require(:post).permit(:description, :public)
  end

  def authorize_post
    unless @post.public? || @post.user == current_user || current_user.has_role?(:admin)
      # flash[:alert] = "You are not authorized to view this post."
      redirect_to posts_path
    end
  end
  
end


  # Finds the post (@post = Post.find(params[:id])).
  # Checks if the current user is authorized:
  # If the user is an admin, they can proceed.
  # If the user is the owner of the post, they can proceed.
  # Otherwise, the user is blocked and redirected to root_path with an error message.