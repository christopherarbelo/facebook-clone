Rails.application.routes.draw do
  get 'comments/create'
  get 'comments/destroy'
  root 'posts#index'

  # likes controller
  devise_for :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  get 'likes/:likable_type/:likable_id', to: 'likes#index', as: :likes
  post 'likes/:likable_type/:likable_id/create', to: 'likes#create', as: :like
  delete 'likes/:likable_type/:likable_id/destroy', to: 'likes#destroy', as: :unlike

  # users controller
  get 'profile', to: 'users#profile'
  get 'profiles/:id', to: 'users#profile', as: :user_profile
  get 'users/friends'

  match 'send_friend_request/:friend_id', to: 'users#send_friend_request', as: :send_friend_request, via: :post
  match 'accept_friend_request/:friend_id', to: 'users#accept_friend_request', as: :accept_friend_request, via: :post
  match 'remove_friend/:friend_id', to: 'users#remove_friend', as: :remove_friend, via: :delete
  match 'cancel_friend_request/:friend_id', to: 'users#cancel_friend_request', as: :cancel_friend_request, via: :post

  get 'friends', to: 'users#friends'
end
