class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :following, through: :following_relationships, source: :followee
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followee_id"
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :achievements
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"
  validates_presence_of :username, :name, :daily_calorie_goal
  validates :username, uniqueness: true
  validates :daily_calorie_goal, numericality: {greater_than_or_equal_to: 1}

  def first_name
    self.name.split(" ")[0]
  end

  def recent_exercises
    self.exercises.order(created_at: :desc).limit(6)
  end

  def recent_meals
    self.foods.order(created_at: :desc).limit(6)
  end

  def achievement_timeline
    timeline_user_ids = [self.id, self.following.distinct.pluck(:id)].flatten
    Achievement.where(user_id: timeline_user_ids)
  end

end
