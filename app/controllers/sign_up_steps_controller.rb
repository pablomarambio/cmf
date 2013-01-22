class SignUpStepsController < ApplicationController
  include Wicked::Wizard
  before_filter :find_user
  steps :set_email, :set_social_networks, :set_statement

  def show
    render_wizard 
  end

  def update
    @user.attributes = params[:user]
    render_wizard @user
  end

  def set_email
    @user = current_user
  end

  def set_statement
  end

  def find_user
    @user = User.find(session[:user_id])
  end

end
