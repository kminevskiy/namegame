Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users
  resources :games, only: [:index, :create, :new] do
    member do
      get 'play'
      get 'report'
      post 'submit'
    end
  end
end
