class AuthProvidersController < ApplicationController
  before_filter :find_user

	def auth_callback
		provider = params[:provider]
		omniauth = request.env['omniauth.auth']
		Rails.logger.debug omniauth.to_yaml

		# continue only if hash and parameter exist
		return if omniauth.nil? or provider.nil?
			
		# map the returned hashes to our variables first - the hashes differ for every authentication provider
		raise "Invalid AuthProvider: #{provider}" unless self.private_methods.any? { |m| m == "auth_hash_for_#{provider}".to_sym }
		h = send "auth_hash_for_#{provider}".to_s, omniauth

		raise "Invalid uid" unless h[:id]
		auth = AuthProvider.find_by_provider_and_uid(provider, h[:id])
		Rails.logger.debug "Auth provider found for user #{auth.user_id}" if auth
		Rails.logger.debug "No auth provider found for [#{provider}-#{h[:id]}]" if auth.nil?

		if user_signed_in?
			# if this authentication provider is not linked to the account, add it
			if !auth
				@user.add_auth_provider h
				flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
			else
				flash[:notice] = provider + ' is already linked to your account.'
			end
			redirect_to profile_path
		else
			# check if user has already signed in using this authentication provider and continue with sign in process if yes
			if auth
				flash[:notice] = 'Welcome back, ' + auth.username
				sign_in auth.user and return
			end
			# at this point we are facing a new user... so he must be signing up
			raise "Unknown user trying to log in" unless signing_up?
			@user.add_auth_provider h
			sign_in @user
      redirect_to profile_path
		end
	end

	private

	def auth_hash_for_facebook omniauth
		hash = {}
		hash[:id] = omniauth['extra']['raw_info']['id']
		hash[:email] = omniauth['info']['email']
		hash[:real_name] = omniauth['info']['name']
		# el username será su nombre combinado
		hash[:username] = hash[:real_name].gsub(/[\*\-_\.]/,"").gsub(/\b/, "_")
		hash[:profile_uri] = omniauth['extra']['urls']['public_profile']
		hash[:avatar] = omniauth['info']['image']
		hash[:provider_name] = omniauth['provider']
		hash
	end

	def auth_hash_for_twitter omniauth
		hash = {}
		hash[:id] = omniauth['uid']
		hash[:email] = nil # Twitter API never returns the email address
		hash[:real_name] = omniauth['info']['name']
		hash[:avatar] = omniauth['info']['image']
		hash[:username] = omniauth['info']['nickname']
		hash[:profile_uri] = omniauth['info']['urls']['Twitter']
		hash[:provider_name] = omniauth['provider']
		hash
	end

	def auth_hash_for_linkedin omniauth
		hash = {}
		hash[:id] = omniauth['uid']
		hash[:email] = omniauth['info']['email']
		hash[:real_name] = omniauth['extra']['raw_info']['name']
		hash[:username] = omniauth['extra']['raw_info']['username']
		hash[:profile_uri] = omniauth['extra']['raw_info']['link']
		hash[:avatar] = omniauth['info']['image']
		hash[:provider_name] = omniauth['provider']
		hash
	end

	def auth_hash_for_github omniauth
		hash = {}
		hash[:id] = omniauth['uid']
		hash[:email] = nil # GH API never returns the email address
		hash[:real_name] = omniauth['info']['image']
		hash[:avatar] = omniauth['info']['image']
		hash[:username] = omniauth['info']['nickname']
		hash[:profile_uri] = omniauth['info']['urls']['GitHub']
		hash[:provider_name] = omniauth['provider']
		hash
	end

	def auth_hash_for_google_oauth2 omniauth
		hash = {}
		hash[:id] = omniauth['uid']
		hash[:email] = omniauth['info']['email']
		hash[:real_name] = omniauth['info']['name']
		hash[:avatar] = omniauth['info']['image']
		# el username será su nombre combinado
		hash[:username] = hash[:real_name].gsub(/[\*\-_\.]/,"").gsub(/\b/, "_")
		hash[:profile_uri] = omniauth['extra']['raw_info']['link']
		hash[:provider_name] = omniauth['provider']
		hash
	end

end
