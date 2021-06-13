Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  # likes controller
  get 'likes/:likable_type/:likable_id', to: 'likes#index', as: :likes
  post 'likes/:likable_type/:likable_id/create', to: 'likes#create', as: :like
  delete 'likes/:likable_type/:likable_id/destroy', to: 'likes#destroy', as: :unlike

  # profiles controller
  resource :profile, only: [:show, :edit, :update]
  get 'profiles/:id', to: 'profiles#show', as: :profiles

  # users controller
  get 'friends', to: 'users#friends'
  get 'users/index', to: 'users#index', as: :users
  match 'send_friend_request/:friend_id', to: 'users#send_friend_request', as: :send_friend_request, via: :post
  match 'accept_friend_request/:friend_id', to: 'users#accept_friend_request', as: :accept_friend_request, via: :post
  match 'remove_friend/:friend_id', to: 'users#remove_friend', as: :remove_friend, via: :delete
  match 'cancel_friend_request/:friend_id', to: 'users#cancel_friend_request', as: :cancel_friend_request, via: :post
end
