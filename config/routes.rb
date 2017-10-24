Rails.application.routes.draw do
  devise_for :users
  resources :users, param: :slug, only: [:index, :show] do
    member do
      post 'follow'
      delete 'unfollow'
      post 'block'
      delete 'unblock'
      post 'mute'
      delete 'unmute'
      get 'blocked'
      get 'muted'
      get 'followers'
      get 'following'
    end
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
  end
  resources :achievements, only: [:new, :create]
  resources :foods, only: [:show, :edit, :update, :destroy]
  resources :exercises, only: [:show, :edit, :update, :destroy]
  get '/activity-feed' => 'activity_feed#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end