class UsersController < ApplicationController
  def destroy
    if user_signed_in?
      current_user.destroy
      Rails.logger.warn "Destroyed user #{current_user}"
    end
    redirect_to root_path
  end
end