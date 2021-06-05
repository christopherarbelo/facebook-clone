Rails.application.routes.draw do
  root 'posts#index'

  # likes controller
  devise_for :users
  resources :posts do
    resources :likes, only: [:create, :destroy, :index]
  end

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
