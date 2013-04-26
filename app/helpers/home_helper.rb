module HomeHelper
	
	def has_twitter?
		has_social_network? "twitter"
	end
	def has_linkedin?
		has_social_network? "linkedin"
	end
	def has_googleplus?
		has_social_network? "google_oauth2"
	end
	def has_facebook?
		has_social_network? "facebook"
	end
	def has_github?
		has_social_network? "github"
	end
	def facebook_url
		social_network_url "facebook"
	end
	def github_url
		social_network_url "github"
	end
	def googleplus_url
		social_network_url "google_oauth2"
	end
	def linkedin_url
		social_network_url "linkedin"
	end
	def twitter_url
		social_network_url "twitter"
	end

	def has_social_network? sn_name
		@user.auth_providers.any? {|ap| ap.provider == sn_name}
	end

	def social_network_url sn_name
		@user.auth_providers.where("provider = ?", sn_name).first.profile_uri
	end

	def name_options
		@user.auth_providers.map{|ap| ["#{ap.uname} (#{ap.provider})", ap.provider]}
	end

	def in_edit_profile
		params[:controller] == "profile" and 
			params[:action] == "profile"
	end

	def in_my_public_profile
		params[:controller] == "profile" and 
			params[:action] == "public_profile" and
			@user.id == current_user.id
	end

	def in_login
		params[:controller] == "sessions" and 
			params[:action] == "new"
	end
end
