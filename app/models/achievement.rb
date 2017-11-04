class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  validates_presence_of :activity, :user, :completed_on

  after_create :find_or_create_daily_total
  after_commit :add_to_daily_total, on: :create

  def activity_attributes=(values)
    if values.key?(:calories_burned)
      self.activity = Exercise.new(values)
    else
      self.activity = Food.new(values)
    end
  end

  private

  def find_or_create_daily_total
    DailyTotal.find_or_create_daily_total_for(self)
  end

  def add_to_daily_total
    daily_total = DailyTotal.find_or_create_daily_total_for(self)
    if self.activity_type == "Food"
      daily_total.update(total_calories_in: daily_total.total_calories_in += self.activity.calories, net_calories: daily_total.net_calories += self.activity.calories)
    else
      daily_total.update(total_calories_out: daily_total.total_calories_out += self.activity.calories_burned, net_calories: daily_total.net_calories -= self.activity.calories_burned)
    end
  end

end
