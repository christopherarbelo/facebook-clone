class Comment < ApplicationRecord
  # associations
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likable, dependent: :destroy

  # validations
  validates :post_id, :user_id, :message, presence: true

  # scopes / helpers
  def liked?(current_user)
    self.likes.where(user_id: current_user.id).any?
  end
end
