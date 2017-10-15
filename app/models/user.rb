require 'cgi'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :following, through: :following_relationships, source: :followee
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followee_id"
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :blocked_relationships, class_name: "Block"
  has_many :blocked_users, through: :blocked_relationships
  has_many :muted_relationships, class_name: "Mute"
  has_many :muted_users, through: :muted_relationships
  has_many :achievements
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"

  validates_presence_of :name, :daily_calorie_intake_goal
  validates :email, uniqueness: true
  validates :daily_calorie_intake_goal, numericality: {greater_than_or_equal_to: 1}
  
  after_create :update_slug_column
  before_save :set_slug, on: :update, unless: :slug_set_properly? 

  def first_name
    self.name.split(" ")[0]
  end

  def recent_exercises
    self.exercises.order(created_at: :desc).limit(6)
  end

  def recent_meals
    self.foods.order(created_at: :desc).limit(6)
  end

  def achievement_following_timeline
    timeline_user_ids = [self.id, self.following.distinct.pluck(:id)].flatten
    Achievement.where(user_id: timeline_user_ids).order(updated_at: :desc)
  end

  def blocked?(user)
    !!self.blocked_users.find_by(id: user.id)
  end

  def blocked_by?(user)
    user.blocked?(self)
  end

  def block(user)
    !!find_follower_relationship_with(user).try(:block) || !!Block.create(user: self, blocked_user: user)
  end

  def unblock(user)
    !!find_blocked_relationship_with(user).try(:destroy)
  end

  def muted?(user)
    !!find_muted_relationship_with(user)
  end

  def mute
    
  end

  def unmute
    
  end

  def following?(user)
    !!find_following_relationship_with(user)
  end

  def follow(user)
    if !self.blocked?(user) && !self.blocked_by?(user) && !self.following?(user)
      self.following_relationships.build(followee: user)
      self.save
    else
      false
    end
  end

  def unfollow(user)
    !!find_following_relationship_with(user).try(:destroy)
  end

  private

  def slug_set_properly?
    self.id != nil && self.slug == get_proper_slug
  end

  def get_proper_slug
    "#{self.id}-#{CGI.escape(self.name.downcase).gsub("+","-")}"
  end

  def update_slug_column
    self.update_column(:slug, get_proper_slug)
  end

  def set_slug
    self.slug = get_proper_slug
  end

  def find_follower_relationship_with(user)
    self.follower_relationships.find_by(follower: user)
  end

  def find_following_relationship_with(user)
    self.following_relationships.find_by(followee: user)
  end

  def find_blocked_relationship_with(user)
    self.blocked_relationships.find_by(blocked_user: user)
  end

  def find_muted_relationship_with(user)
    self.muted_relationships.find_by(muted_users: user)
  end

end
