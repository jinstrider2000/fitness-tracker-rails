Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :achievements, only: [:new, :create ,:index, :destroy]
  resources :foods, only: [:edit, :update, :destroy]
  resources :exercises, only: [:edit, :update, :destroy]
  resources :users, param: :slug do
    get '/' => 'users#show'
    get '/blocked-users' = 'users#index'
    get '/muted-users' = 'users#index'
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
    get '/followers' => 'users#index'
    get '/following' => 'users#index'
    post '/follow' => 'relationships#create'
    delete '/unfollow' => 'relationships#destroy'
    post '/block' => 'blocks#create'
    delete '/unblock' => 'blocks#destroy'
    post '/mute' => 'mutes#create'
    delete '/unmute' => 'mutes#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end