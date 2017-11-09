require 'cgi'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followee
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :blocked_relationships, class_name: "Block", dependent: :destroy
  has_many :blocked_users, through: :blocked_relationships
  has_many :muted_relationships, class_name: "Mute", dependent: :destroy
  has_many :muted_users, through: :muted_relationships
  has_many :achievements, dependent: :destroy
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"
  has_many :daily_totals, dependent: :destroy

  validates_presence_of :name, :daily_calorie_intake_goal, :email
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

  def achievements_ordered_by(order = nil)
    dates_array = (order.try(:downcase) == "ascending" ? self.daily_totals.order(completed_on: :asc).pluck(:completed_on) : self.daily_totals.order(completed_on: :desc).pluck(:completed_on))
    
    [].tap do |array|
      dates_array.each do |date|
        array << self.achievements.where(completed_on: date)
      end
    end
  end

  def exercises_ordered_by(filter = nil, order = nil)
    achievements_table = Achievement.arel_table
    case filter.try(:downcase)
    when "name"
      order.try(:downcase) == "ascending" ? self.exercises.order(name: :asc) : self.exercises.order(name: :desc)
    when "calories burned"
      order.try(:downcase) == "ascending" ? self.exercises.order(calories_burned: :asc) : self.exercises.order(calories_burned: :desc)
    else
      dates_array = (order.try(:downcase) == "ascending" ? self.daily_totals.order(completed_on: :asc).pluck(:completed_on) : self.daily_totals.order(completed_on: :desc).pluck(:completed_on))
      
      [].tap do |array|
        dates_array.each do |date|
          array << self.exercises.where(achievements_table[:completed_on].eq(date))
        end
      end
    end
  end

  def foods_ordered_by(filter = nil, order = nil)
    achievements_table = Achievement.arel_table
    case filter.try(:downcase)
    when "name"
      order.try(:downcase) == "ascending" ? self.foods.order(name: :asc) : self.foods.order(name: :desc)
    when "calories"
      order.try(:downcase) == "ascending" ? self.foods.order(calories: :asc) : self.foods.order(calories: :desc)
    else
      dates_array = (order.try(:downcase) == "ascending" ? self.daily_totals.order(completed_on: :asc).pluck(:completed_on) : self.daily_totals.order(completed_on: :desc).pluck(:completed_on))
      
      [].tap do |array|
        dates_array.each do |date|
          array << self.foods.where(achievements_table[:completed_on].eq(date))
        end
      end
    end
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
    self.unfollow(user) if self.following?(user)
    find_follower_relationship_with(user).destroy if self.follower?(user)
    self.blocked_relationships.build(blocked_user: user)
    self.save
  end

  def unblock(user)
    find_blocked_relationship_with(user).destroy
  end

  def muted?(user)
    !!find_muted_relationship_with(user)
  end

  def mute(user)
    self.muted_relationships.build(muted_user: user)
    self.save
  end

  def unmute(user)
    find_muted_relationship_with(user).destroy
    self.save
  end

  def following?(user)
    !!find_following_relationship_with(user)
  end

  def follower?(user)
    !!find_follower_relationship_with(user)
  end

  def follow(user)
    self.following_relationships.build(followee: user)
    self.save
  end

  def unfollow(user)
    find_following_relationship_with(user).destroy
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
    self.muted_relationships.find_by(muted_user: user)
  end

end
