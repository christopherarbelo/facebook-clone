class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def friends
    @friends = current_user.friends.all
    @friend_requests = current_user.friend_requests
  end

  def index
    @users = User.all
  end

  def profile
    @user = params[:id] ? User.find(params[:id]) : current_user
    @not_current_user_profile = @user.id != current_user.id
    if @not_current_user_profile
      @user_relationship = current_user.relationship(@user)
      @user_action = @user_relationship.action_user_id == current_user.id
    end
  end

  def send_friend_request
    handle_relationship(0, 'Friend request sent!')
  end

  def accept_friend_request
    handle_relationship(2, 'Friend request accepted!')
  end

  def remove_friend
    handle_relationship(1, 'Removed friend')
  end

  def reject_friend_request
    handle_relationship(1, 'Friend request rejected')
  end

  def cancel_friend_request
    handle_relationship(1, 'Friend request canceled')
  end

  private

  def friend_object
    User.find(params[:friend_id])
  end

  def handle_relationship(status, message)
    current_user.change_relationship(friend_object, status)
    flash[:notice] = message
    redirect_to user_profile_path(params[:friend_id])
  end
end
