class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @likes = Like.likes(params[:post_id])
  end

  def create
    @liked_post = Like.new(user_id: current_user.id, likable_id: params[:post_id], likable_type: 'Post')
    if @liked_post.save
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong. Like didn\'t process'
      redirect_to root_path
    end
  end

  def destroy
    @liked_post = Like.find_by(user_id: params[:id], likable_id: params[:post_id], likable_type: 'Post')
    if @liked_post
      @liked_post.destroy
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong. Dislike didn\'t process'
      redirect_to root_path
    end
  end
end
