Rails.application.routes.draw do
  resources :teams
  resources :companies
  resources :organizaions
  devise_for :users
  resources :users, only: [:index, :edit, :update]
  resources :addresses
  resources :deliveries
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_scope :user do
    authenticated :user do
      root :to => "deliveries#new", as: :authenticated_root
    end
    
    root :to => "devise/sessions#new"
  end

  namespace :deliveries do
    post 'csvs', to: 'csvs#create'
    get 'csvs/template', to: 'csvs#get_template'
  end
end
