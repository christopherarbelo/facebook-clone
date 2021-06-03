class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts
  has_many :relationships, foreign_key: 'user_one_id'

  validates :name, presence: true, length: { in: 2..30 }
  validates_associated :posts, :relationships

  def friends
    friends_ids = Relationship.where(user_one_id: id, status: 2).pluck(:user_two_id)
    friends_ids += Relationship.where(user_two_id: id, status: 2).pluck(:user_one_id)
    User.where(id: friends_ids)
  end

  def add_friend(friend)
    if id < friend.id
      relationships.create(user_two_id: friend.id, status: 2, action_user_id: id)
    else
      relationships.create(user_one_id: friend.id, status: 2, action_user_id: id)
    end
  end
end
