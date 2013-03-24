class UsersController < ApplicationController
  before_filter :find_user

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated"
      @user.complete_profile if @user.signing_up? and @user.can_move_to_signed_up?
    else
      flash[:alert] = "Unable to update profile"
    end
    redirect_to profile_path
  end
end