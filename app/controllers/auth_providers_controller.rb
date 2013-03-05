class AuthProvidersController < ApplicationController
  include Wicked::Wizard
  before_filter :find_user
	before_filter :authenticate_user!, :except => [:create]

	def index
		# get all authentication providers assigned to the current user
		@auth_providers = current_user.auth_providers.all
	end

	def destroy
		# remove an authentication provider linked to the current user
		@auth_provider = current_user.auth_providers.find(params[:id])
		@auth_provider.destroy
		
		redirect_to auth_providers_path
	end

end
