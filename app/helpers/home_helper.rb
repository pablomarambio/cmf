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

	def has_social_network? sn_name
		@user.auth_providers.any? {|ap| ap.provider == sn_name}
	end
end
