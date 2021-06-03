class Relationship < ApplicationRecord
  belongs_to :user, foreign_key: 'user_one_id'

  validates :status, :user_one_id, :user_two_id, :action_user_id, presence: true
end
