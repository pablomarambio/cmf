# Do not forget to restart your server after changing this file
Rails.application.config.middleware.use OmniAuth::Builder do  

  provider :facebook, '402883789797877', '3fe235e5d8e212371b21a1b6a17e8a79' if Rails.env.development?
  provider :facebook, '150544564969139', '0975c80e44d6d10ed6936e8600bdf438' if Rails.env.production?
  provider :twitter, 'PQEPJB8yLrsgvXpD8vxOaA', 'DppfJtzvgzD98rRWhV7gS2FuI6TIt8mJesFODncw4ro' # All environments
  provider :github, '69892830880bb291b062', '4e2a9023098129d2c04b2396c19f9d9a47f87867' if Rails.env.development?
  provider :github, '76ad2632feb70969cd8b', '675fd73334bc6c33ec4e851399312616b7f50321' if Rails.env.production?
  provider :google_oauth2, '859120276641.apps.googleusercontent.com', 'lDOLq0jivII65XhbBozJjhko' if Rails.env.development?
  provider :google_oauth2, '383049092118.apps.googleusercontent.com', 'gXyesspKXaWJAuE9uyRlAAOW' if Rails.env.production?
  provider :linkedin, 'h98gvbofk1ye', 'hbJXOxWKQjpE5bDY' if Rails.env.development?
  provider :linkedin, 'f421a871qznh', 'IWuBoEMRNLlhHHT5' if Rails.env.production?

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
end
