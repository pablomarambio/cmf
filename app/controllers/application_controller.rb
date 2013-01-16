class ApplicationController < ActionController::Base
	protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end

	def after_sign_in_path_for(r)
		return path_for_user(r) if r.is_a? User
		raise "Unidentified resource #{r.class}"
	end

	def after_sign_up_path_for(r)
		return path_for_user(r) if r.is_a? User
		raise "Unidentified resource #{r.class}"
	end

	protected
	def path_for_user u
		return set_statement_path unless u.comment
		return edit_user_registration_path
	end

end
