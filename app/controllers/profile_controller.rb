class ProfileController < ApplicationController
  before_filter :find_user, :only => [:profile]

  def profile
    render :layout => false
  end

  def public_profile
    @user = User.find_by_username(params[:username])
    render :layout => false
  end

  def all_profiles
    @users = User.all
  end

end
