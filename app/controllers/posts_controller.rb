class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_owner, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.all_contents.for_user(current_user)
    @post = current_user.posts.build
  end

  def show
    @post = Post.all_contents.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      broadcast_to_friends @post
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    redirect_to root_path
  end

  private

  def broadcast_to_friends(post)
    current_user.friends.each do |friend|
      ActionCable.server.broadcast("post_feed_#{friend.id}", 'New Post')
    end
  end

  def post_params
    params.require(:post).permit(:body)
  end

  def is_owner
    @post = Post.find(params[:id])
    unless @post.belongs_to_user?(current_user)
      flash[:error] = "You don't own that resource!"

      redirect_to root_path
    end
  end
end
