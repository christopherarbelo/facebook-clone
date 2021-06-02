Rails.application.routes.draw do
  get 'users/friends'
  devise_for :users
  root 'posts#index'
  resources :posts
  get 'friends', to: 'users#friends'
end
