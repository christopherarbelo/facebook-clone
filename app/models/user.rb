class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # associations
  has_many :notifications, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, -> { where(likable_type: 'Post') }, class_name: 'Like'
  has_many :liked_comments, -> { where(likable_type: 'Comment') }, class_name: 'Like'
  has_one :profile, dependent: :destroy

  # validations
  validates :name, presence: true, length: { in: 2..30 }
  validates_associated :posts, :relationships

  # callbacks
  after_create_commit :make_profile
  before_destroy :destroy_relationships

  # scopes / helpers
  def relationships
    Relationship.where(user_one_id: id).or(Relationship.where(user_two_id: id))
  end
  
  def friends
    friends_ids = Relationship.where(user_one_id: id, status: 2).pluck(:user_two_id)
    friends_ids += Relationship.where(user_two_id: id, status: 2).pluck(:user_one_id)
    User.where(id: friends_ids)
  end
  
  def friend_requests
    friends_ids = Relationship.where(user_one_id: id, status: 0).where.not(action_user_id: id).pluck(:user_two_id)
    friends_ids += Relationship.where(user_two_id: id, status: 0).where.not(action_user_id: id).pluck(:user_one_id)
    User.where(id: friends_ids)
  end

  def change_relationship(other_user, status)
    user_one, user_two = ordered_users(other_user)
    users_relationship = Relationship.find_by(user_one_id: user_one, user_two_id: user_two)
    if users_relationship
      users_relationship.update(status: status, action_user_id: id)
    else    
      Relationship.create(user_one_id: user_one, user_two_id: user_two, status: status, action_user_id: id)
    end
  end

  def relationship(other_user)
    user_one, user_two = ordered_users(other_user)
    Relationship.find_by(user_one_id: user_one, user_two_id: user_two)
  end

  def friends?(other_user)
    relationship(other_user).status == 2
  end

  private

  def ordered_users(other_user)
    id < other_user.id ? [id, other_user.id] : [other_user.id, id]
  end

  def make_profile
    self.create_profile
  end

  def destroy_relationships
    relationships.destroy_all
  end
end
