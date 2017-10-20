class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  validates_presence_of :activity, :user


  after_create :create_daily_total, unless: :daily_total_exists?
  after_commit :add_to_daily_total, on: :create
  after_validation :update_daily_total, on: :update

  def activity_attributes=(values)
    if values.key?(:calories_burned)
      self.activity = Exercise.new(values)
    else
      self.activity = Food.new(values)
    end
  end

  private

  def create_daily_total
    DailyTotal.create(user: self.user, created_at: self.activity.created_at, updated_at: self.updated_at)
  end

  def find_daily_total
    arel = DailyTotal.arel_table
    DailyTotal.find_by(arel[:user_id].eq(self.user.id).and(arel[:created_at].gteq(self.activity.created_at.beginning_of_day)))
  end

  def daily_total_exists?
    !!find_daily_total
  end

  def add_to_daily_total
    daily_total = find_daily_total
    if self.activity_type == "Food"
      daily_total.update(total_calories_in: daily_total.total_calories_in += self.activity.calories, net_calories: daily_total.net_calories += self.activity.calories)
    else
      daily_total.update(total_calories_out: daily_total.total_calories_out += self.activity.calories_burned, net_calories: daily_total.net_calories -= self.activity.calories_burned)
    end
  end

  def update_daily_total
    daily_total = find_daily_total
    old_record = Achievement.find_by(id: self.id)
    if self.activity_type == "Food"
      daily_total.update(total_calories_in: daily_total.total_calories_in - old_record.activity.calories + self.activity.calories, net_calories: daily_total.net_calories - old_record.calories + self.activity.calories)
    else
      daily_total.update(total_calories_out: daily_total.total_calories_out + old_record.calories_burned - self.activity.calories_burned, net_calories: daily_total.net_calories + old_record.calories_burned - self.activity.calories_burned)
    end
  end

end
