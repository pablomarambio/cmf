class ProfileController < ApplicationController
  before_filter :find_user, :except => [:public_profile, :all_profiles]
  layout "public"

  def profile
  end

  def public_profile
    @user = User.find_by_username(params[:username])
  end

  def all_profiles
    @users = User.all
  end

  def data
    images = 
    render :json => {success: true, img: @user.main_picture}
  end

  def set_img
    @user.set_img params[:provider]
    @user.save!
    render :json => {success: true}
  end

end
