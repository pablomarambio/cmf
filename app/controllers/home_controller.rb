class HomeController < ApplicationController
	def index
		@users = User.all
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
		redirect_to set_identity_path
	end

end
