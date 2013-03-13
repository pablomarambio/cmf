Cmf::Application.routes.draw do
  resources :answers, :except => :new
  get "answers/:username/:token" => "answers#new", :as => "new_answer"
  get "evaluate/:id/:token" => "answers#evaluate_answer", :as => "evaluate_answer"
  put "set_evaluation/:id" => "answers#set_evaluation", :as => "set_evaluation"
  post "payment/create" => "payments#create", :as => "new_payment"
  get "payment_result/:id/:random" => "payments#payment_router", :as => "payment_router"

  get "users_profile" => "home#users_profile", :as => "users_profile"

  resources :messages, :except => [:new]
  get "message/new/:username/:payment_id/:payment_random" => "messages#new", :as => "new_message"


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
