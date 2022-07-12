Rails.application.routes.draw do
  resources :teams
  resources :companies
  resources :organizaions
  devise_for :users
  resources :users, only: [:index, :edit, :update]
  resources :addresses
  resources :deliveries
  resources :products, only:[:index, :edit, :update]
  resources :delivery_items, only: [:create, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_scope :user do
    authenticated :user do
      root :to => "deliveries#new", as: :authenticated_root
    end
    
    root :to => "devise/sessions#new"

    get 'settings', to: 'devise/registrations#edit', as: :settings
  end

  namespace :deliveries do
    post 'csvs', to: 'csvs#create'
    get 'csvs/template', to: 'csvs#get_template'
  end

  default_url_options host: ENV["HOST"]

  namespace :users do
    get 'oauth/exact-callback', to: 'oauth#exact_callback'
  end
  
  get 'integrations/find-order', to: 'integrations#find_order', as: :find_order

  get 'my-team', to: 'teams#show', as: :my_team
  get 'my-company', to: 'companies#show', as: :my_company
  get 'edit-my-team', to: 'teams#edit', as: :edit_my_team
  get 'edit-my-company', to: 'companies#edit', as: :edit_my_company
  get 'edit-my-user', to: 'users#edit', as: :edit_my_user
  get 'pending-deliveries', to: 'deliveries/pending#index', as: :pending_deliveries
  get 'my-deliveries', to: 'deliveries/my#index', as: :my_deliveries
  post 'complete-delivery', to: 'deliveries#complete', as: :complete_delivery
  post 'add-to-delivery', to: 'products#add_to_delivery', as: :add_to_delivery
  post 'remove-from-delivery', to: 'products#remove_from_delivery', as: :remove_from_delivery
end
