Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :achievements, only: [:new, :create, :destroy]
  resources :foods, only: [:show, :edit, :update, :destroy]
  resources :exercises, only: [:show, :edit, :update, :destroy]
  resources :users, param: :slug, only: [:show] do
    member do
      get 'blocked', as: "blocked_users"
      get 'muted', as: 'muted_users'
      get 'feed', as: 'user_feed'
      get 'followers', 'followers'
      get 'following', 'following'
    end
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
    post '/follow' => 'relationships#create'
    delete '/unfollow' => 'relationships#destroy'
    post '/block' => 'blocks#create'
    delete '/unblock' => 'blocks#destroy'
    post '/mute' => 'mutes#create'
    delete '/unmute' => 'mutes#destroy'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end