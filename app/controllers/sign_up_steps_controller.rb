class SignUpStepsController < ApplicationController
  before_filter :find_user, :except => [:enter_wizard, :step_set_threshold]

  def enter_wizard
  	if current_user
  		flash[:notice] = "If you wish to register another user, sign out first"
  		redirect_to user_path and return 
  	end
  	redirect_to step_set_threshold_path
  end

  def step_set_threshold
  	return unless threshold = params[:threshold]
    @user = User.new(params[:user])
    @user.threshold = threshold
    raise "Couldn't save" unless @user.save
    session[:user_id] = @user.id
    redirect_to step_set_network
  end

  def step_set_network
  end

end
