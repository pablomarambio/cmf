class AuthProvidersController < ApplicationController
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

	def create
		# get the authentication provider parameter from the Rails router
		params[:provider] ? provider_route = params[:provider] : provider_route = 'no authentication provider (invalid callback)'

		# get the full hash from omniauth
		omniauth = request.env['omniauth.auth']

		Rails.logger.debug omniauth.to_yaml
		# continue only if hash and parameter exist
		if omniauth and params[:provider]
			
			# map the returned hashes to our variables first - the hashes differ for every authentication provider
			if provider_route == 'facebook'
				omniauth['extra']['raw_info']['email'] ? email =  omniauth['extra']['raw_info']['email'] : email = ''
				omniauth['extra']['raw_info']['name'] ? name =  omniauth['extra']['raw_info']['name'] : name = ''
				omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
				omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
			elsif provider_route == 'twitter'
				email = ''    # Twitter API never returns the email address
				omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
				omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
				omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
			else
				# we have an unrecognized authentication provider, just output the hash that has been returned
				render :text => omniauth.to_yaml
				#render :text => uid.to_s + " - " + name + " - " + email + " - " + provider
				return
			end
		
			# continue only if provider and uid exist
			if uid != '' and provider != ''
					
				# nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
				if !user_signed_in?
					
					# check if user has already signed in using this authentication provider and continue with sign in process if yes
					auth = AuthProvider.find_by_provider_and_uid(provider, uid)
					if auth
						flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
						sign_in_and_redirect(:user, auth.user)
					else
						# check if this user is already registered with this email address; get out if no email has been provided
						if email != ''
							# search for a user with this email address
							existinguser = User.find_by_email(email)
							if existinguser
								# map this new login method via a authentication provider to an existing account if the email address is the same
								existinguser.auth_providers.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
								flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
								sign_in_and_redirect(:user, existinguser)
							else
								# let's create a new user: register this user and add this authentication method for this user
								name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us

								# new user, set email, a random password and take the name from the authentication provider
								user = User.new :email => email, :password => SecureRandom.hex(10), :name => name, :haslocalpw => false

								# add this authentication provider to our new user
								user.auth_providers.build(:provider => provider, :uid => uid, :user_id => name, :uemail => email)

								user.save!

								# flash and sign in
								flash[:myinfo] = 'Your account on CommunityGuides has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
								sign_in_and_redirect(:user, user)
							end
						else
							flash[:error] =  provider_route.capitalize + ' can not be used to sign-up on CommunityGuides as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + provider_route.capitalize + ' from your profile.'
							redirect_to new_user_session_path
						end
					end
				else
					# the user is currently signed in
					
					# check if this authentication provider is already linked to his/her account, if not, add it
					auth = AuthProvider.find_by_provider_and_uid(provider, uid)
					if !auth
						current_user.auth_providers.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
						flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
						redirect_to auth_providers_path
					else
						flash[:notice] = provider_route.capitalize + ' is already linked to your account.'
						sign_in_and_redirect(:user, current_user)
					end  
				end  
			else
				flash[:error] =  provider_route.capitalize + ' returned invalid data for the user id.'
				redirect_to new_user_session_path
			end
		else
			flash[:error] = 'Error while authenticating via ' + provider_route.capitalize + '.'
			redirect_to new_user_session_path
		end
	end
end
