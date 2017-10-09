Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index]
  resources :achievements, only: [:new, :create ,:index]
  resources :foods, only: [:edit, :update, :destroy]
  resources :exercises, only: [:edit, :update, :destroy]
  resources :users, param: :slug do
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
    get '/followers' => 'users#index'
    get '/following' => 'users#index'
    post '/follow' => 'relationship#create'
    delete '/unfollow' => 'relationship#destroy'
    patch '/block' => 'relationship#update'
    put '/block' => 'relationship#update'
    patch '/unblock' => 'relationship#update'
    put '/unblock' => 'relationship#update'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end