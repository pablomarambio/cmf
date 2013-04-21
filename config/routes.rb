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
  get "users_profile" => "profile#users_profile", :as => "users_profile"
  scope "/profile" do
    get "/" => "profile#profile", :as => "profile"
    get "/data" => "profile#data", :as => "pf_get_data"
    post "/img" => "profile#set_img", :as => "pf_set_img", :constraints => { provider: /\w+/ }
  end
  get "usr/:username" => "profile#public_profile", :constraints  => { :username => /[\w_\-\.]+/}

  # --- Messages --- #
  resources :messages, :except => [:new]
  get "message/new/:username/:payment_id/:payment_random" => "messages#new", :as => "new_message", :constraints  => { :username => /[\w_\-\.]*/}

  # --- Auth Providers --- #
  match "auth/:provider/callback" => "auth_providers#auth_callback"

  # --- Register(Sign Up) --- #
  scope "r" do
    get   "signup"    =>  "sign_up_steps#enter_wizard"      ,  :as => "signup_wizard"
    get   "threshold" =>  "sign_up_steps#step_set_threshold",  :as => "step_set_threshold"
    post  "threshold" =>  "sign_up_steps#step_set_threshold",  :as => "step_set_threshold"
    get   "network"   =>  "sign_up_steps#step_set_network",    :as => "step_set_network"
  end

  # --- Users --- #
  resources :users, :only => :update
  authenticated :user do
    root :to => 'profile#profile'
  end

  root :to => "sign_up_steps#index"
  devise_for :users, :path => "auth"
end
