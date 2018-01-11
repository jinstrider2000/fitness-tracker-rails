class Achievement < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Completed On"].freeze
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"].freeze
  VALID_ACTIVITIES = ["Food", "Exercise"].freeze
  VALID_ACTIVITY_PARAMS = {
    %w[name calories_burned].sort => "Exercise",
    %w[name calories].sort => "Food"
  }.freeze

  belongs_to :activity, polymorphic: true, dependent: :destroy, validate: true
  belongs_to :user
  belongs_to :daily_total, optional: true
  validates_presence_of :activity, :completed_on, :user
  validates_associated :activity

  after_validation :find_or_create_daily_total, on: :create
  after_create :add_to_daily_total
  before_update :update_daily_total_and_activity
  before_destroy :subtract_from_daily_total

  extend FitnessTracker::SortableActivity

  def activity_attributes=(values)
    if activity.present?
      activity.assign_attributes(values)
    else
      klass = VALID_ACTIVITY_PARAMS[values.keys.sort].constantize
      self.activity = klass.new(values)
    end 
  end

  def self.valid_activity?(activity_name)
    VALID_ACTIVITIES.any? {|activity| activity == activity_name.try(:capitalize)}
  end

  private

  def find_or_create_daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
  end

  def add_to_daily_total
    daily_total = self.daily_total
    if self.activity_type == 'Food'
      daily_total.total_calories_in += self.activity.calories
      daily_total.net_calories += self.activity.calories
      daily_total.save
    else
      daily_total.total_calories_out += self.activity.calories_burned
      daily_total.net_calories -= self.activity.calories_burned
      daily_total.save
    end
  end

  def update_daily_total_and_activity
    old_activity = self.activity.class.find_by(id: self.activity.id)
    old_daily_total = self.daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
    new_daily_total = self.daily_total
    if new_daily_total == old_daily_total
      if self.activity_type == 'Food'
        new_daily_total.update(total_calories_in: new_daily_total.total_calories_in - old_activity.calories + self.activity.calories, net_calories: new_daily_total.net_calories - old_activity.calories + self.activity.calories)
      else
        new_daily_total.update(total_calories_out: new_daily_total.total_calories_out - old_activity.calories_burned + self.activity.calories_burned, net_calories: new_daily_total.net_calories + old_activity.calories_burned - self.activity.calories_burned)
      end
    else
      if self.activity_type == 'Food'
        old_daily_total.update(total_calories_in: old_daily_total.total_calories_in - old_activity.calories, net_calories: old_daily_total.net_calories - old_activity.calories)
        new_daily_total.update(total_calories_in: new_daily_total.total_calories_in + self.activity.calories, net_calories: new_daily_total.net_calories + self.activity.calories)
      else
        old_daily_total.update(total_calories_out: old_daily_total.total_calories_out - old_activity.calories_burned, net_calories: old_daily_total.net_calories + old_activity.calories_burned)
        new_daily_total.update(total_calories_out: new_daily_total.total_calories_out + self.activity.calories_burned, net_calories: new_daily_total.net_calories - self.activity.calories_burned)
      end
      old_daily_total.destroy if old_daily_total.achievements.count == 1
    end
    self.activity.save
  end

  def subtract_from_daily_total
    daily_total = self.daily_total
    if daily_total.achievements.count > 1
      if self.activity_type == 'Food'
        daily_total.total_calories_in -= self.activity.calories
        daily_total.net_calories -= self.activity.calories 
      else
        daily_total.total_calories_out -= self.activity.calories_burned
        daily_total.net_calories += self.activity.calories_burned
      end
      daily_total.save
    else
      daily_total.destroy
    end
  end

end