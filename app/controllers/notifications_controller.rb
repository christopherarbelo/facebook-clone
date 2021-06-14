class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_owner?
  
  def destroy
    notification = Notification.find(params[:id])
    if notification
      notification.destroy
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong with notifications'
      redirect_to root_path
    end
  end

  private

  def is_owner?
    notification = Notification.find(params[:id])
    unless notification.user_id == current_user.id
      flash[:error] = 'Unauthorized!'
      redirect_to root_path
    end

    true
  end
end
