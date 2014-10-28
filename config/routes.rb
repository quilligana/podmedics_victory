PodmedicsVictory::Application.routes.draw do

  # Static pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about', as: 'about'
  get '/faqs', to: 'static_pages#faqs', as: 'faqs'
  get '/library', to: 'static_pages#library', as: 'library'
  get '/terms', to: 'static_pages#terms', as: 'terms'
  get '/contact', to: 'static_pages#contact', as: 'contact'
  get '/support', to: 'static_pages#support', as: 'support'
  get '/press', to: 'static_pages#press', as: 'press'
  get '/app', to: 'static_pages#app', as: 'app'
  get '/trial_questions', to: 'static_pages#trial_questions', as: 'trial_questions'
  resources :courses, only: [:index]
  resources :posts, only: [:index, :show]

  # RSS feed redirects
  match '/Podmedics/Podmedics/rss.xml' => redirect('http://feeds.feedburner.com/podmedics'), via: :get
  match '/feeds/podcasts' => redirect('http://feeds.feedburner.com/podmedics'), :as => :feed, via: :get

  # Authentication
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'users#new', as: :signup
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, except: [:index, :destroy] do
    get 'email', on: :member
  end

  post 'unsubscribed', to: 'users#unsubscribed', as: :unsub
  get 'unsubscribe', to: 'users#unsubscribe'
  get 'unsubscribe/:unsubscribe_token', to: 'users#unsubscribe', as: :unsubscribe_token

  resources :password_resets, only: [:create, :edit, :update]

  # Omniauth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: 'sessions#new', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Transactions/Stripe Events
  get ':user_id/buy', to: 'transactions#new', as: :show_buy
  post ':user_id/buy/:permalink', to: 'transactions#create', as: :buy
  get ':user_id/pickup', to: 'transactions#pickup', as: :pickup
  get '/receive_paypal', to: 'transactions#receive_paypal', as: :receive_paypal
  get ':user_id/cancel_transaction', to: 'transactions#cancel_transaction', as: :cancel_transaction
  resources :stripe_events, only: [:create]

  # Dashboards and admin
  match '/admin' => redirect('/admin/dashboard'), via: :get
  resource :dashboard, only: :show
  namespace :admin do
    resource :dashboard, only: :show
    resources :categories, except: :delete
    resources :specialties
    resources :questions, only: [:index]
    resources :videos, except: :delete do
      member do
        get 'move_up'
        get 'move_down'
        get 'send_notifications'
        get 'send_test_notifications'
        get 'mark_proofread'
      end
      resources :questions, except: [:index] do
        member do
          get 'mark_proofread'
        end
      end
    end
    resources :users do
      member { get 'send_1w_reminder'}
    end
    resources :authors
    resources :faqs
    resources :courses
    resources :questions
    resources :products
    resources :sales, only: [:index, :show]
    resources :newsletters do
      member do
        get 'send_test'
        get 'send_newsletter'
      end
    end
    resources :posts
    resources :comments, except: [:show]
    resources :badges
    resources :quizes
    resources :notes, only: [:index, :show]
  end

  # Specialty/Video
  resources :videos, only: [:show, :index] do
    resources :questions, only: :index
    get 'video', to: 'hosted_files#video', as: 'download_video'
    get 'audio', to: 'hosted_files#audio', as: 'download_audio'
    get 'slides', to: 'hosted_files#slides', as: 'download_slides'
  end
  get 'tags/:tag', to: 'videos#index', as: :tag
  match 'questions/answer', to: 'questions#answer', via: [:get, :post]
  get 'questions/result', to: 'questions#result'
  resources :questions, only: :show

  resources :specialties, only: [:show] do
    resources :questions, controller: :specialty_questions, as: :questions
    get 'questions/load/:page', to: 'specialty_questions#load', as: :question_load
    resources :specialty_unlocks, only: [:create]
  end

  get 'specialties/:id/exam', to: 'questions#specialty_index', as: :specialty_exam

  resources :comments do
    member do
      get 'vote'
      get 'accept'
    end
  end

  resources :notes, only: [:create, :update, :show, :index] do
    get 'load', on: :member
  end
  get 'notes/specialty/:specialty_id', to: 'notes#index', as: :specialty_notes
  get 'notes/category/:category_id', to: 'notes#index', as: :category_notes

  # VimeosController
  get 'vimeos/completed', to: 'vimeos#completed', as: :vimeos_completed
  get 'vimeos/paused', to: 'vimeos#paused', as: :vimeos_paused

  # API

  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
      resources :specialties
      resources :questions do
        collection do
          get 'count'
          get 'sample'
        end
      end
    end
  end

end
