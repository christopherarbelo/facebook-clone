class Post < ApplicationRecord
  # validations
  validates :body, presence: true
  
  # associations
  belongs_to :user
  has_many :likes, as: :likable, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  # scopes / helpers
  scope :latest, -> { order(created_at: :desc) }
  scope :own_posts, ->(user) { where(user_id: user.id).latest }
  scope :all_contents, -> { includes(user: [:profile], comments: { user: [:profile] }) }

  def self.for_user(current_user)
    users_network_ids = current_user.friends.map { |friend| friend.id }
    users_network_ids << current_user.id
    self.where(user_id: users_network_ids).latest
  end

  def belongs_to_user?(current_user)
    self.user_id == current_user.id
  end

  def liked?(current_user)
    self.likes.where(user_id: current_user.id).any?
  end
end
