class Post < ApplicationRecord
  scope :lastest, -> { order(created_at: :desc) }

  validates :body, presence: true

  belongs_to :user

  def self.for_user(current_user)
    users_network_ids = current_user.friends.map { |friend| friend.id }
    users_network_ids << current_user.id
    self.where(user_id: users_network_ids)
  end
end
