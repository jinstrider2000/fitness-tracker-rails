class Achievement < ApplicationRecord

  VALID_ACTIVITIES = ["Food", "Exercise"]
  VALID_FILTER_OPTIONS = ["Date"]
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"]

  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  belongs_to :daily_total
  validates_presence_of :activity, :user, :completed_on, :daily_total

  before_validation :find_or_create_daily_total, on: :create
  # before_update :update_daily_total, on: :update
  after_create :add_to_daily_total

  def activity_attributes=(values)
    if values.key?(:calories_burned)
      self.activity = Exercise.new(values)
    else
      self.activity = Food.new(values)
    end
  end

  def self.valid_activities
    VALID_ACTIVITIES
  end

  def self.valid_activity?(activity_name)
    VALID_ACTIVITIES.any? {|activity| activity == activity_name}
  end

  extend FitnessTracker::SortableActivity

  private

  # include FitnessTracker::DailyTotalUpdatable

  def find_or_create_daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
  end

  def add_to_daily_total
    if self.activity_type == "Food"
      self.daily_total.update(total_calories_in: self.daily_total.total_calories_in += self.activity.calories, net_calories: self.daily_total.net_calories += self.activity.calories)
    else
      self.daily_total.update(total_calories_out: self.daily_total.total_calories_out += self.activity.calories_burned, net_calories: self.daily_total.net_calories -= self.activity.calories_burned)
    end
  end

end
