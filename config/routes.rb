Rails.application.routes.draw do
  root 'news_feed#index'
  get '/news-feed' => 'news_feed#index'
  devise_for :users, controllers: {registrations: 'users/registrations'}, skip: [:passwords]
  
  resources :users, param: :slug, only: [:index, :show], module: "users", controller: "user_actions" do
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
  end

  scope 'users/:slug', as: 'user' do
    resources :achievements, only: [:new, :index]
  end
  
  resources :achievements, except: [:new, :index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end