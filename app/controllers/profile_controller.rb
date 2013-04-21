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
    images = @user.auth_providers.map do |ap|
      if @user.main_picture == ap.image
        nil
      else
        { provider: ap.provider, image: ap.image }
      end 
    end.compact
    puts images.inspect
    render :json => {success: true, main_picture: @user.main_picture, alt_pics: images}
  end

  def set_img
    @user.set_img params[:provider]
    @user.save!
    render :json => {success: true}
  end

end
