Rails.application.routes.draw do
  root   'static_pages#home'
  post   '/next_month/:id',   to: 'attendance#next_month'
  post   '/last_month/:id',   to: 'attendance#last_month'
  post   '/select',      to: 'attendance#select'
  post   '/create/:id',  to: 'attendance#create'
  post   '/update/:work_id',  to: 'attendance#update'
  post   '/update/',  to: 'attendance#update'
  get    '/attendance/select_time',  to: 'attendance#select_time'
  get    '/attendance/edit/:id',    to: 'attendance#edit'
  get    '/attendance/attendance/:id', to: 'attendance#attendance'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end