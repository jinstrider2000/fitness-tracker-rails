class DailyTotal < ApplicationRecord
  belongs_to :user
  has_many :achievements
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"
  validates_presence_of :user, :completed_on

  def self.find_or_create_daily_total_for(achievement)
    self.find_by(user: achievement.user, completed_on: achievement.completed_on) || self.create(user: achievement.user, completed_on: achievement.completed_on)
  end

end
