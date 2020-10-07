Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users

  resources :jobposts
  resources :applications
  resources :likes

  get 'adhome', to: 'adminhomes#adhome'
  post 'adhome/evals', to: 'adminhomes#getAdminEvaluations'
  post 'adhome/check', to: 'adminhomes#checkSignUpEmail'
  
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
