class Achievement < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Date"].freeze
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"].freeze
  VALID_ACTIVITIES = ["Food", "Exercise"].freeze
  VALID_ACTIVITY_PARAMS = {
    [:name, :calories_burned].sort => "Exercise",
    [:name, :calories ].sort => "Food"
  }.freeze
  VALID_DAILY_TOTAL_INSTRUCTIONS = {
    :add_to_daily_total => {
      'Food' => ['self.daily_total.update(total_calories_in: self.daily_total.total_calories_in += self.activity.calories, net_calories: self.daily_total.net_calories += self.activity.calories)'],
      'Exercise' => ['self.daily_total.update(total_calories_out: self.daily_total.total_calories_out += self.activity.calories_burned, net_calories: self.daily_total.net_calories -= self.activity.calories_burned)']
    },
    :update_daily_total => {
      true => {
        'Food' => ['new_daily_total.update(total_calories_in: new_daily_total.total_calories_in - old_activity.calories + self.activity.calories, net_calories: new_daily_total.net_calories - old_activity.calories + self.activity.calories)'],

        'Exercise' => ['new_daily_total.update(total_calories_out: new_daily_total.total_calories_out - old_activity.calories_burned + self.activity.calories_burned, net_calories: new_daily_total.net_calories + old_activity.calories_burned - self.activity.calories_burned)']
      },
      false => {
        'Food' => ['old_daily_total.update(total_calories_in: old_daily_total.total_calories_in - old_activity.calories, net_calories: old_daily_total.net_calories - old_activity.calories)', 'new_daily_total.update(total_calories_in: new_daily_total.total_calories_in + self.activity.calories, net_calories: new_daily_total.net_calories + self.activity.calories)'],

        'Exercise' => ['old_daily_total.update(total_calories_out: old_daily_total.total_calories_out - old_activity.calories_burned, net_calories: old_daily_total.net_calories + old_activity.calories_burned)', 'new_daily_total.update(total_calories_out: new_daily_total.total_calories_out + self.activity.calories_burned, net_calories: new_daily_total.net_calories - self.activity.calories_burned)']
      }
    }
  }

  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  belongs_to :daily_total
  validates_presence_of :activity, :completed_on, :user, :daily_total

  before_validation :find_or_create_daily_total, on: :create
  after_create :add_to_daily_total
  before_update :update_daily_total

  extend FitnessTracker::SortableActivity

  def activity_attributes=(values)
    klass = VALID_ACTIVITY_PARAMS[values.keys.sort].try(:constantize)
    self.activity = klass.try(:new, values)
  end

  def self.valid_activity?(activity_name)
    VALID_ACTIVITIES.any? {|activity| activity == activity_name.try(:capitalize)}
  end

  private

  def find_or_create_daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
  end

  def add_to_daily_total
    VALID_DAILY_TOTAL_INSTRUCTIONS[__callee__][self.activity.class.to_s].each {|formula| eval formula}
  end

  def update_daily_total
    old_activity = self.activity.class.find_by(id: self.id)
    old_daily_total = self.daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
    new_daily_total = self.daily_total
    VALID_DAILY_TOTAL_INSTRUCTIONS[__callee__][new_daily_total == old_daily_total][self.activity.class.to_s].each {|formula| eval formula}
    old_activity.destroy
  end

end