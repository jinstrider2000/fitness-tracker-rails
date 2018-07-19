Rails.application.routes.draw do

  root 'news_feed#index'
  get '/current-user' => Users::UserActionsController.action(:current_user_json), as: "current_user_json"
  get '/:locale' => 'news_feed#index'

  scope ':locale', constraints: {locale: /en|es/} do
    get '/news-feed' => 'news_feed#index'
    devise_for :users, controllers: {registrations: 'users/registrations'}, skip: [:passwords, :omniauth_callbacks]
  end

  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}, scope: '/(:locale)', locale: /en|es/ do
    devise_for :users, skip: :omniauth_callbacks
  end  
  
  scope ':locale', constraints: {locale: /en|es/} do
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
      collection do
        get 'most-active-today' => 'user_actions#most_active_today'
      end
    end
  end

  scope ':locale', constraints: {locale: /en|es/} do
    scope 'users/:slug', as: 'user' do
      resources :achievements, param: :id, only: [:new, :index] do
        member do
          get 'previous-id'
          get 'next-id'
        end
      end
      scope 'achievements/:activity_type', as: 'achievement' do
        get 'new-form-fields' => 'achievements#new_form_fields'
      end
    end
  end

  scope ':locale', constraints: {locale: /en|es/} do
    resources :achievements, except: [:new, :index]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end