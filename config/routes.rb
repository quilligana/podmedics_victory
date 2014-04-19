PodmedicsVictory::Application.routes.draw do

  # Static pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about', as: 'about'
  get '/faqs', to: 'static_pages#faqs', as: 'faqs'
  get '/library', to: 'static_pages#library', as: 'library'
  get '/terms', to: 'static_pages#terms', as: 'terms'
  get '/contact', to: 'static_pages#contact', as: 'contact'
  get '/support', to: 'static_pages#support', as: 'support'
  get 'plans', to: 'static_pages#plans', as: 'plans'
  resources :courses, only: [:index]

  # Authentication
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'users#new', as: :signup
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, except: :destroy
  resources :password_resets

  # Omniauth
  match 'auth/:provider/callback', to: 'sessions#omniauthcreate', via: [:get, :post]
  match 'auth/failure', to: 'sessions#new', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Dashboards and admin
  resource :dashboard, only: :show
  namespace :admin do
    resource :dashboard, only: :show
    resources :categories, except: :delete 
    resources :specialties
    resources :videos do
      member do
        get 'move_up'
        get 'move_down'
      end
      resources :questions
    end
    resources :users
    resources :authors
    resources :faqs
    resources :courses
    resources :questions
  end

  # Specialty/Video
  resources :videos, only: :show do
    resources :questions, only: :index
    get 'video', to: 'hosted_files#video', as: 'download_video'
    get 'audio', to: 'hosted_files#audio', as: 'download_audio'
    get 'slides', to: 'hosted_files#slides', as: 'download_slides'
  end  
  match 'questions/answer', to: 'questions#answer', via: [:get, :post]
  get 'questions/result', to: 'questions#result'
  resources :questions, only: :show

  resources :specialties, only: [:show] do
    resources :questions, controller: :specialty_questions, as: :questions
    get 'questions/load/:page', to: 'specialty_questions#load', as: :question_load
  end

  get 'specialties/:id/exam', to: 'questions#specialty_index', as: :specialty_exam

  resources :comments do
    get 'vote', on: :member
    get 'accept', on: :member
  end

  resources :notes, only: [:create, :update] do
    get 'load', on: :member
  end

  # VimeosController
  get 'vimeos/completed', to: 'vimeos#completed', as: :vimeos_completed
  get 'vimeos/paused', to: 'vimeos#paused', as: :vimeos_paused

end
