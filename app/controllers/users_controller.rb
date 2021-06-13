class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def friends
    @friends = current_user.friends.map { |friend| user_relationship_hash friend }
    @friend_requests = current_user.friend_requests.map { |friend_request| user_relationship_hash friend_request }
  end

  def index
    @users = User.all.map { |user| user_relationship_hash user }
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
    redirect_to profiles_path(params[:friend_id])
  end

  def user_relationship_hash(user)
    not_current_user_profile = user.id != current_user.id
    relationship_variables = { not_current_user_profile: not_current_user_profile }
    returning_hash = { user: user }
    
    if not_current_user_profile
      user_relationship = current_user.relationship(user)
      relationship_variables[:user_relationship] = user_relationship
      user_action = user_relationship ? user_relationship.action_user_id == current_user.id : nil
      relationship_variables[:user_action] = user_action
    else
      relationship_variables[:user_relationship] = nil
      relationship_variables[:user_action] = nil
    end

    returning_hash[:relationship_variables] = relationship_variables
    returning_hash
  end
end
