class Profile < ApplicationRecord
  belongs_to :user

  # asset pipeline
  has_one_attached :profile_photo
end
