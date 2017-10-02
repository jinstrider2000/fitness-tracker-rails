Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :achievements, only: [:new, :index]
  resources :foods, only: [:create, :edit, :update, :destroy]
  resources :exercises, only: [:create, :edit, :update, :destroy]
  resources :users, param: :slug do
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
    get '/followers' => 'users#index'
    get '/following' => 'users#index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end