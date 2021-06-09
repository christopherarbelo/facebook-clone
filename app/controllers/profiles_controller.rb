class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.includes(:profile).find(params[:id] || current_user.id)
    @not_current_user_profile = @user.id != current_user.id
    if @not_current_user_profile
      @user_relationship = current_user.relationship(@user)
      @user_action = @user_relationship.action_user_id == current_user.id if @user_relationship
    end
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @updated_profile = current_user.profile.update(profile_params)

    if @updated_profile
      flash[:notice] = 'Profile updated!'
      redirect_to profile_path
    else
      flash[:alert] = 'Profile did not update'
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:biography)
  end
end
