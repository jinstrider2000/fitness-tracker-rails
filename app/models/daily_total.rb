class DailyTotal < ApplicationRecord

  VALID_TOTAL_FORMULAS = { 
    :add_to_daily_total => {
      'Food' => ['self.daily_total.update(total_calories_in: self.daily_total.total_calories_in += self.activity.calories, net_calories: self.daily_total.net_calories += self.activity.calories)'],
      'Exercise' => ['self.daily_total.update(total_calories_out: self.daily_total.total_calories_out += self.activity.calories_burned, net_calories: self.daily_total.net_calories -= self.activity.calories_burned)']
    },
    :update_daily_total => {
        true => {
          'Food' => ['new_daily_total.update(total_calories_in: new_daily_total.total_calories_in - old_activity.calories + self.calories, net_calories: new_daily_total.net_calories - old_activity.calories + self.calories)'],
          'Exercise' => ['new_daily_total.update(total_calories_out: new_daily_total.total_calories_out - old_activity.calories_burned + self.calories_burned, net_calories: new_daily_total.net_calories + old_activity.calories_burned - self.calories_burned)']
        },
        false => {
          'Food' => ['old_daily_total.update(total_calories_in: old_daily_total.total_calories_in - old_activity.calories, net_calories: old_daily_total.net_calories - old_activity.calories)', 'new_daily_total.update(total_calories_in: new_daily_total.total_calories_in + self.calories, net_calories: new_daily_total.net_calories + self.calories)'],
          'Exercise' => ['old_daily_total.update(total_calories_out: old_daily_total.total_calories_out - old_activity.calories_burned, net_calories: old_daily_total.net_calories + old_activity.calories_burned)', 'new_daily_total.update(total_calories_out: new_daily_total.total_calories_out + self.calories_burned, net_calories: new_daily_total.net_calories - self.calories_burned)']
        }
    }
  }

  belongs_to :user
  has_many :achievements
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"
  validates_presence_of :user, :completed_on

  def self.find_or_create_daily_total_for(achievement)
    self.find_by(user: achievement.user, completed_on: achievement.completed_on) || self.create(user: achievement.user, completed_on: achievement.completed_on)
  end

end
