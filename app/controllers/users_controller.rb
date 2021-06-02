class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def friends
    @friends = current_user.friends.all
  end

  def index
    @users = User.all
  end
end
