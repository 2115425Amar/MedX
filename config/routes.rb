require "sidekiq/web"
Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: "users/registrations",sessions: "users/sessions" }
  # GET /users/sign_in → login form
  # POST /users/sign_in → login
  # DELETE /users/sign_out → logout
  # GET /users/sign_up → sign up form
  # POST /users → register
  # PATCH /users → update registration
  # GET /users/edit → edit profile

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
  end

  # POST /posts/:post_id/comments → comments#create
  # DELETE /posts/:post_id/comments/:id → comments#destroy
  # POST /posts/:post_id/likes → likes#create
  # DELETE /posts/:post_id/likes/:id → likes#destroy


  resources :comments do
    resources :likes, only: [ :create, :destroy ]
  end
  # POST /comments/:comment_id/likes → likes#create
  # DELETE /comments/:comment_id/likes/:id → likes#destroy

  resource :profile, only: [:show, :update], controller: 'users', action: :profile
  patch 'profile/update', to: 'users#update_profile', as: :update_profile
  # GET /profile → users#show (acts as profile)
  # PATCH /profile → users#update
  # PATCH /profile/update → users#update_profile

  resources :reports, only: [ :index ] do
    collection do
      get "download_report"
    end
  end
  # GET /reports → reports#index
  # GET /reports/download_report → reports#download_report

  resources :manage_users, only: [ :index, :create, :new , :destroy] do
    member do
      patch "toggle_status", to: "manage_users#toggle_status"
    end
    collection do
      get "upload"
      post "upload_users"
    end
  end
  # GET /manage_users → manage_users#index
  # POST /manage_users → manage_users#create
  # GET /manage_users/new → manage_users#new
  # DELETE /manage_users/:id → manage_users#destroy
  # PATCH /manage_users/:id/toggle_status → manage_users#toggle_status
  # GET /manage_users/upload → manage_users#upload
  # POST /manage_users/upload_users → manage_users#upload_users


  # Add users resource
  resources :users, only: [:index, :show, :edit, :update]
  # GET /users → users#index
  # GET /users/:id → users#show
  # GET /users/:id/edit → users#edit
  # PATCH /users/:id → users#update

  get 'dashboard', to: 'dashboard#index'

  # http://localhost:3000/sidekiq
  mount Sidekiq::Web => "/sidekiq"

  root "home#index"
end