class HomeController < ApplicationController
	def index
		@users = User.all
	end

  def step_set_threshold
    @user = User.new
  end

	def set_threshold
		threshold = params[:threshold]
		unless threshold
			flash.now[:notice] = "Please enter your threshold in USD"
			render :step_set_threshold and return
		end

		session[:threshold] = threshold
		redirect_to set_email_path
	end

	def set_email
		email = params[:email]
		unless email
			flash.now[:email] = "Please enter your email"
			render :step_set_email and return
		end

		session[:email] = email
		# jumps to auth_providers_controller
		redirect_to set_identity_path
	end

	def set_statement
		statement = params[:user][:comment]
		name = params[:user][:name]

		unless statement and name
			flash.now[:notice] = "Please enter your name and statement"
			render :step_name_and_statement and return
		end

		current_user.comment = statement
		current_user.name = name
		current_user.save

		redirect_to set_social_networks_path
	end

end
