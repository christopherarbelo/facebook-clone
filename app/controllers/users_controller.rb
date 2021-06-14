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
    add_notification action_user_id: current_user.id, kind: 0
    redirect_to profiles_path(params[:friend_id])
  end

  def accept_friend_request
    handle_relationship(2, 'Friend request accepted!')
    remove_notification user_id: current_user.id, action_user_id: friend_object.id, kind: 0
    add_notification action_user_id: current_user.id, kind: 1
    redirect_to profiles_path(params[:friend_id])
  end

  def remove_friend
    handle_relationship(1, 'Removed friend')
    remove_notification user_id: current_user.id, action_user_id: friend_object.id, kind: 1
    redirect_to profiles_path(params[:friend_id])
  end

  def reject_friend_request
    handle_relationship(1, 'Friend request rejected')
    remove_notification user_id: current_user.id, action_user_id: friend_object.id, kind: 0
    redirect_to profiles_path(params[:friend_id])
  end

  def cancel_friend_request
    handle_relationship(1, 'Friend request canceled')
    remove_notification user_id: friend_object.id, action_user_id: current_user.id, kind: 0
    redirect_to profiles_path(params[:friend_id])
  end

  private

  def remove_notification(notification_hash = {})
    notification = Notification.find_by notification_hash
    notification.destroy if notification
  end

  def add_notification(notification_hash = {})
    notification = friend_object.notifications.build(notification_hash)
    notification.save
  end

  def friend_object
    @_friend_object ||= User.find(params[:friend_id])
  end

  def handle_relationship(status, message)
    current_user.change_relationship(friend_object, status)
    flash[:notice] = message
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
