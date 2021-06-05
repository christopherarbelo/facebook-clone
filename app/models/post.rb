class Post < ApplicationRecord
  scope :lastest, -> { order(created_at: :desc) }
  validates :body, presence: true
  belongs_to :user
  has_many :likes, as: :likable

  def self.for_user(current_user)
    users_network_ids = current_user.friends.map { |friend| friend.id }
    users_network_ids << current_user.id
    self.where(user_id: users_network_ids)
  end

  def belongs_to_user?(current_user)
    self.user_id == current_user.id
  end

  def liked?(current_user)
    self.likes.where(user_id: current_user.id).any?
  end
end
