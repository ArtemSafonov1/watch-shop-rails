Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  get 'user/home', to: 'user#index'
  namespace :admin do
    resource :user do
      resources :order
    end
    resources :product, except: [:show]
    get 'export/:id', to: 'product#export'
    get 'export_json/:id', to: 'product#export_json'
    get 'gallery/:id', to: 'product#destroy_gallery'

    resource :product do
      resources :related, only: [:index, :edit, :update]
    end
    resources :category, except: [:show]
    resources :brand
    get 'user/:id', to: 'user#show'
    get 'user/edit/:id', to: 'user#edit_page'
    put 'user/edit/:id', to: 'user#edit'
    delete 'user/:id', to: 'user#destroy'
    get 'manage-for-users', to: 'user#users_managing'
  end
  #match 'lang/:locale', to: 'index#change_locale', as: :change_locale, via: [:get]
  #scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    use_doorkeeper
    #match 'lang/:locale', to: 'index#change_locale', as: :change_locale, via: [:get]
    root to: 'main#index'
    get '/about', to: 'main#about'
    resources :brands, only: [:index, :show]
    resources :product, only: [:show, :index]
    resources :category, only: [:show]
    resources :search, only: [:index]
    resources :order, except: [:index, :edit]
    resource :cart, only: [:destroy, :show] do
      resources :items, only: [:destroy, :create]
    end

    namespace :api do
      namespace :v1 do
        resources :profile, only: [:index]
        resources :products, only: [:index]
      end
    end
  #end
  get '*unmatched_route', to: 'application#not_found'
end
