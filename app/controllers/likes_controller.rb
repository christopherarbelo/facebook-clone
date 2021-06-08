class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @likes = Like.likes(params[:likable_id], params[:likable_type])
  end

  def create
    @likable_content = Like.new(likes_params)
    if @likable_content.save
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong. Like didn\'t process'
      redirect_to root_path
    end
  end

  def destroy
    @likable_content = Like.find_by(likes_params)
    if @likable_content
      @likable_content.destroy
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong. Dislike didn\'t process'
      redirect_to root_path
    end
  end

  private

  def likes_params
    params_hash = params.permit(:likable_type, :likable_id)
    params_hash[:user_id] = current_user.id
    params_hash
  end
end
