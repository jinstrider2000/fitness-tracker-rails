class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  validates_presence_of :activity, :user


  after_create :create_daily_total, unless: :daily_total_exists?
  after_commit :add_to_daily_total, on: :create

  def activity_attributes=(values)
    if values.key?(:calories_burned)
      self.activity = Exercise.new(values)
    else
      self.activity = Food.new(values)
    end
  end

  private

  def create_daily_total
    DailyTotal.create(user: self.user, created_at: self.activity.created_at, updated_at: self.activity.updated_at)
  end

  def daily_total_exists?
    !!DailyTotal.find_daily_total_for(self.user, self.activity)
  end

  def add_to_daily_total
    daily_total = DailyTotal.find_daily_total_for(self.user, self.activity)
    if self.activity_type == "Food"
      daily_total.update(total_calories_in: daily_total.total_calories_in += self.activity.calories, net_calories: daily_total.net_calories += self.activity.calories)
    else
      daily_total.update(total_calories_out: daily_total.total_calories_out += self.activity.calories_burned, net_calories: daily_total.net_calories -= self.activity.calories_burned)
    end
  end

end
