Cmf::Application.routes.draw do
  match "auth/:provider/callback" => "auth_providers#create"
  resources :auth_providers, :only => [:index, :create, :destroy]

  authenticated :user do
    root :to => 'home#index'
  end

  # Setup flow: set price
  get "setup/set_threshold" => "home#step_set_threshold", :as => "set_threshold"
  post "setup/set_threshold" => "home#set_threshold", :as => "set_threshold"

  # Setup flow: set mail
  get "setup/set_email" => "home#step_set_email", :as => "set_email"
  post "setup/set_email" => "home#set_email", :as => "set_email"

  # Setup flow: sign up
  get "setup/set_identity" => "home#step_sign_up", :as => "set_identity"
  post "setup/set_identity" => "home#set_identity", :as => "set_identity"

  # Setup flow: name and statement
  get "setup/set_statement" => "home#step_name_and_statement", :as => "set_statement"
  post "setup/set_statement" => "home#set_statement", :as => "set_statement"

  # Setup flow: link social networks
  get "setup/set_social_networks" => "home#step_set_social_networks", :as => "set_social_networks"
  post "setup/set_social_networks" => "home#set_social_networks", :as => "set_social_networks"

  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :users
end