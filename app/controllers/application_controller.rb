class ApplicationController < ActionController::Base
	protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end

  def find_user
    if user_signed_in?
      @user = current_user
    elsif session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

  def signing_up?
    session[:user_id]
  end
  
end
