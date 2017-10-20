Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :achievements, only: [:new, :create]
  resources :foods, only: [:show, :edit, :update, :destroy]
  resources :exercises, only: [:show, :edit, :update, :destroy]
  resources :users, param: :slug, only: [:show] do
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
    post '/follow' => 'relationships#create'
    delete '/unfollow' => 'relationships#destroy'
    post '/block' => 'blocks#create'
    delete '/unblock' => 'blocks#destroy'
    post '/mute' => 'mutes#create'
    delete '/unmute' => 'mutes#destroy'
    get '/blocked' => 'users#blocked'
    get '/muted' => 'users#muted'
    get '/activity-feed' => 'users#activity_feed'
    get '/followers' => 'users#followers'
    get '/following' => 'users#following'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end