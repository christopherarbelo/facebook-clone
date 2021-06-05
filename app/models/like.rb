class Like < ApplicationRecord
  belongs_to :likable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:likable_id, :likable_type] }

  scope :likes, ->(post_id) { includes(:user).where(likable_id: post_id) }
end
