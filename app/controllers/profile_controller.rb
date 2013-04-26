class ProfileController < ApplicationController
  before_filter :authenticate_user!, :except => [:public_profile, :all_profiles]
  before_filter :find_user, :except => [:public_profile, :all_profiles]
  layout "public"

  def profile
    @first_time_in_profile = (@user.signing_up? and @user.auth_providers.count < 2)
  end

  def public_profile
    @user = User.find_by_username(params[:username])
    @this_is_my_profile = (user_signed_in? and @user.id == current_user.id)
  end

  def all_profiles
    @users = User.all
  end

  def data
    render :json => {success: true, 
      status: @user.status,
      username: @user.username,
      main_picture: @user.main_picture, 
      alt_pics: @user.alternative_pictures,
      name: @user.name,
      alt_names: @user.alternative_names,
      provider: @user.provider_name
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
    @user.comment = params[:comment] if params[:comment]
    @user.email = params[:email] if params[:email]
    @user.threshold = params[:price] if params[:price]
    # We change status only if the request contains the whole form
    @user.complete_profile if (@user.signing_up? and params[:price] and params[:comment] and params[:email])
    @user.save!
    render :json => {success: true}
  end

end
