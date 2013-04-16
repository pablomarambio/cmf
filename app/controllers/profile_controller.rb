class ProfileController < ApplicationController
  before_filter :find_user, :only => [:profile]
  layout "public"

  def profile
  end

  def public_profile
    @user = User.find_by_username(params[:username])
  end

  def all_profiles
    @users = User.all
  end

end
