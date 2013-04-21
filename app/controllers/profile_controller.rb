class ProfileController < ApplicationController
  before_filter :authenticate_user!, :except => [:public_profile, :all_profiles]
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
    render :json => {success: true, 
      main_picture: @user.main_picture, 
      alt_pics: @user.alternative_pictures,
      name: @user.name,
      alt_names: @user.alternative_names
    }
  end

  def set_main_pic
    @user.set_main_picture params[:provider]
    @user.save!
    render :json => {success: true}
  end

  def set_name
    @user.set_name params[:provider]
    @user.save!
    render :json => {success: true}
  end

  def save
    @user.comment = params[:comment]
    @user.email = params[:email]
    @user.threshold = params[:price]
    @user.save!
    render :json => {success: true}
  end

end
