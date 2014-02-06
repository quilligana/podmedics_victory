PodmedicsVictory::Application.routes.draw do

  # Static pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about', as: 'about'
  get '/faqs', to: 'static_pages#faqs', as: 'faqs'
  get '/library', to: 'static_pages#library', as: 'library'
  get '/terms', to: 'static_pages#terms', as: 'terms'
  get '/contact', to: 'static_pages#contact', as: 'contact'

  # Authentication
  get 'login', to: 'sessions#new', as: 'login'
  resources :sessions, only: [:new, :create, :destroy]

  # Dashboards
  resource :dashboard, only: [:show]

  # Admin
end
