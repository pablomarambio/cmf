Cmf::Application.routes.draw do

  # --- Answers --- #
  resources :answers, :except => :new
  get "answers/:username/:token" => "answers#new", :as => "new_answer", :constraints  => { :username => /[\w_\-\.]*/}
  get "evaluate/:id/:token" => "answers#evaluate_answer", :as => "evaluate_answer"
  put "set_evaluation/:id" => "answers#set_evaluation", :as => "set_evaluation"

  # --- Payments --- #
  post "payment/create" => "payments#create", :as => "new_payment"
  get "payment_result/:id/:random" => "payments#payment_router", :as => "payment_router"

  # --- Home --- #
  get "users_profile" => "home#users_profile", :as => "users_profile"
  get "profile" => "home#profile"
  get "profile/:username" => "home#public_profile", :constraints  => { :username => /[\w_\-\.]+/}

  # --- Messages --- #
  resources :messages, :except => [:new]
  get "message/new/:username/:payment_id/:payment_random" => "messages#new", :as => "new_message", :constraints  => { :username => /[\w_\-\.]*/}

  # --- Auth Providers --- #
  match "auth/:provider/callback" => "auth_providers#auth_callback"
  resources :auth_providers, :only => [:index, :create, :destroy]

  # --- Register(Sign Up) --- #
  resources :sign_up_steps

  # --- Users --- #
  resources :users
  authenticated :user do
    root :to => 'home#index'
  end

  root :to => "home#index"
  devise_for :users, :path => "auth"
end
