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


	def auth_provider_create
		# get the authentication provider parameter from the Rails router
		params[:provider] ? provider_route = params[:provider] : provider_route = 'no authentication provider (invalid callback)'

		# get the full hash from omniauth
		omniauth = request.env['omniauth.auth']

		Rails.logger.debug omniauth.to_yaml
		# continue only if hash and parameter exist
		if omniauth and params[:provider]
			
			# map the returned hashes to our variables first - the hashes differ for every authentication provider
			if provider_route == 'facebook'
				omniauth['info']['email'] ? email =  omniauth['info']['email'] : email = ''
				omniauth['extra']['raw_info']['name'] ? name =  omniauth['extra']['raw_info']['name'] : name = ''
				omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
				omniauth['extra']['raw_info']['username'] ?  username =  omniauth['extra']['raw_info']['username'] : username = ''
				omniauth['extra']['raw_info']['link'] ?  url =  omniauth['extra']['raw_info']['link'] : url = ''
				omniauth['info']['image'] ? image =  omniauth['info']['image'] : image = ''
				omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
			elsif provider_route == 'twitter'
				email = @user.nil? ? '' : @user.email   # Twitter API never returns the email address
				omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
				omniauth['info']['image'] ? image =  omniauth['info']['image'] : image = ''
				omniauth['info']['nickname'] ?  username =  omniauth['info']['nickname'] : username = ''
				omniauth['info']['urls']['Twitter'] ?  url =  omniauth['info']['urls']['Twitter'] : url = ''
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
						sign_in auth.user
            redirect_to profile_path
					else
						# check if this user is already registered with this email address; get out if no email has been provided
						if email != ''
							# search for a user with this email address
							existinguser = User.find_by_email(email)
							if existinguser
								# map this new login method via a authentication provider to an existing account if the email address is the same
								existinguser.auth_providers.create(
									:provider => provider, 
									:uid => uid, 
									:uname => name, 
									:uemail => email,
									:username => username,
									:image => image,
									:profile_uri => url)
                existinguser.main_picture = image
                existinguser.username = username
                existinguser.name = name
                existinguser.save
								flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
                sign_in existinguser
                redirect_to wizard_path(:complete_profile)
								#sign_in_and_redirect(:user, existinguser)
							else
                #Usuario no se registra con el mismo correo que su red social
								# let's create a new user: register this user and add this authentication method for this user
                flash[:error] = "Account email and social network email must be the same"
                redirect_to previous_wizard_path
							end
						else
							flash[:error] =  provider_route.capitalize + ' can not be used to sign-up on Mythreshold.com as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + provider_route.capitalize + ' from your profile.'
              redirect_to next_wizard_path
						end
					end
				else
					# the user is currently signed in
					
					# check if this authentication provider is already linked to his/her account, if not, add it
					auth = AuthProvider.find_by_provider_and_uid(provider, uid)
					if !auth
						current_user.auth_providers.create(
							:provider => provider, 
							:uid => uid, 
							:uname => name, 
							:uemail => email,
							:username => username,
							:image => image,
							:profile_uri => url)

						flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
						redirect_to profile_path
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
