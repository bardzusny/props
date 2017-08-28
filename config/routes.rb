Rails.application.routes.draw do
  mount EasyTokens::Engine, at: 'et'
  root 'home#index'
  get 'app' => 'authenticated#main_app'
  get 'app/*path' => 'authenticated#main_app'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#failure'

  resources :settings, only: :index do
    post :apply, on: :collection
    post :save_slack_channel, on: :collection
  end

  mount Api::Base, at: '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  get '/api/rankings/hero_of_the_week', to: redirect { |params, request| "/api/v1/rankings/hero_of_the_week?#{request.params.to_query}" }
end
