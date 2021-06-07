class Comment < ApplicationRecord
  # associations
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likable

  # validations
  validates :post_id, :user_id, :message, presence: true
end
