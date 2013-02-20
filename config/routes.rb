Cmf::Application.routes.draw do
  resources :messages


  match "auth/:provider/callback" => "sign_up_steps#auth_provider_create"
  resources :auth_providers, :only => [:index, :create, :destroy]

  get "profile" => "home#profile"
  get "profile/:username" => "home#public_profile"

  resources :sign_up_steps
  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  #devise_for :users, :controllers => {:users => "users"}
  devise_for :users, :path => "auth"
  resources :users
end
