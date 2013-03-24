class SignUpStepsController < ApplicationController
  include Wicked::Wizard
  before_filter :find_user, :except => [:create]
  steps :set_email, :set_social_networks, :complete_profile

  def show
    render_wizard 
  end

  def create
    @user = User.new(params[:user])
    @user.status = "threshold"
    if @user.save
      puts @user.inspect
      session[:user_id] = @user.id
      redirect_to wizard_path(steps.first, :user_id => @user.id)
    else
      render "users/new"
    end
  end

  def update
    params[:user][:status] = step.to_s
    params[:user][:status] = 'active' if step == steps.last
    @user.update_attributes(params[:user])
    render_wizard @user
  end

  def set_email
  end

  def set_statement
  end
  
end
