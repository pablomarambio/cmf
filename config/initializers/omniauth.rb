# Do not forget to restart your server after changing this file
Rails.application.config.middleware.use OmniAuth::Builder do  

  provider :facebook, '402883789797877', '3fe235e5d8e212371b21a1b6a17e8a79' if Rails.env.development?
  provider :facebook, '150544564969139', '0975c80e44d6d10ed6936e8600bdf438' if Rails.env.production?

  provider :twitter, 'aI6KYrW35M8IAk2wnzlA', 'rMkMXMuhh5YFKuTKXY0M235N320XtwOW2DMx662Vw2Q'
end