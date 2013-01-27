Cmf::Application.routes.draw do
  match "auth/:provider/callback" => "sign_up_steps#auth_provider_create"
  resources :auth_providers, :only => [:index, :create, :destroy]

  resources :sign_up_steps
  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"

  #devise_for :users, :controllers => {:users => "users"}
  devise_for :users, :path => "auth"
  resources :users
end
