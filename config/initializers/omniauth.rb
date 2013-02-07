# Do not forget to restart your server after changing this file
Rails.application.config.middleware.use OmniAuth::Builder do  

  provider :facebook, '402883789797877', '3fe235e5d8e212371b21a1b6a17e8a79' if Rails.env.development?
  provider :facebook, '150544564969139', '0975c80e44d6d10ed6936e8600bdf438' if Rails.env.production?

  provider :twitter, 'PQEPJB8yLrsgvXpD8vxOaA', 'DppfJtzvgzD98rRWhV7gS2FuI6TIt8mJesFODncw4ro'

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
end
