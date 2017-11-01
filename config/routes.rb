Rails.application.routes.draw do
  root 'activity_feed#show'
  get '/activity-feed' => 'activity_feed#show'
  devise_for :users, controllers: {registrations: 'users/registrations'}, skip: [:passwords]
  
  resources :user_actions, param: :slug, only: [:index, :show], path: 'users', module: "users" do
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

  scope 'users' do
    resources :achievements, only: [:index]
    resources :foods, only: [:index]
    resources :exercises, only: [:index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end