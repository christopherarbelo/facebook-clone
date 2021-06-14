class Notification < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :action_user, class_name: 'User'

  # validations
  validates :user_id, :action_user_id, :kind, presence: true
end
