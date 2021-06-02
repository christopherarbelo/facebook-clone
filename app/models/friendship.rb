class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, uniqueness: { scope: :friend, message: 'a user friendship can only be recorded once' }
end
