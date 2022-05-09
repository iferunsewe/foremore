Rails.application.routes.draw do
  resources :teams
  resources :companies
  resources :organizaions
  devise_for :users
  resources :users
  resources :addresses
  resources :deliveries
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_scope :user do
    authenticated :user do
      root 'deliveries#new', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
