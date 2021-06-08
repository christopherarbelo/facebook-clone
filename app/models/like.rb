class Like < ApplicationRecord
  belongs_to :likable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:likable_id, :likable_type] }

  scope :likes, ->(likable_id, likable_type) { includes(:user).where(likable_id: likable_id, likable_type: likable_type) }
end
