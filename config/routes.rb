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
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'users#new', as: :signup
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  # Omniauth
  match 'auth/:provider/callback', to: 'sessions#omniauthcreate', via: [:get, :post]
  match 'auth/failure', to: 'sessions#new', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Dashboards and admin
  resource :dashboard, only: [:show]
  namespace :admin do
    resource :dashboard, only: [:show]
    resources :categories, only: [:index, :new, :create, :edit, :update]
    resources :specialties
    resources :videos do
      resources :questions
      collection { post :import}
    end
    resources :users
    resources :faqs
    resources :questions do
      collection { post :import}
    end
  end

  # Specialty/Video

  resources :videos, only: [:show] do
    resources :questions, only: [:index]
  end  
  match 'questions/answer', to: 'questions#answer', via: [:get, :post]
  get 'questions/result', to: 'questions#result'
  resources :questions, only: [:show]

  resources :specialties, only: [:show]
  get 'specialties/:id/exam', to: 'questions#specialty_index', as: :specialty_exam

end
