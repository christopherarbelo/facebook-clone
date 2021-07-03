class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[discord]
         
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.discord_data"] && session["devise.discord_data"]['info']
        user.name = data["name"] if user.name.blank?
        user.email = data["email"] if user.email.blank?
        user.valid?
      end
    end
  end

  def password_required?
    super && provider.blank?
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
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
    relation = relationship(other_user)
    !relation.nil? && relation.status == 2
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
