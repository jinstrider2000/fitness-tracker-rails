module DailyTotalUpdatable

  def update_daily_total
    old_activity = self.class.find_by(id: self.id)
    old_daily_total = old_activity.achievement.daily_total
    self.achievement.daily_total = DailyTotal.find_or_create_daily_total_for(self.achievement)
    new_daily_total = self.achievement.daily_total

    if old_daily_total == new_daily_total
      if self.class.to_s == "Food"
        new_daily_total.update(total_calories_in: new_daily_total.total_calories_in - old_activity.calories + self.calories, net_calories: new_daily_total.net_calories - old_activity.calories + self.calories)
      else
        new_daily_total.update(total_calories_out: new_daily_total.total_calories_out - old_activity.calories_burned + self.calories_burned, net_calories: new_daily_total.net_calories + old_activity.calories_burned - self.calories_burned)
      end
    else
      if self.class.to_s == "Food"
        old_daily_total.update(total_calories_in: old_daily_total.total_calories_in - old_activity.calories, net_calories: old_daily_total.net_calories - old_activity.calories)
        new_daily_total.update(total_calories_in: new_daily_total.total_calories_in + self.calories, net_calories: new_daily_total.net_calories + self.calories)
      else
        old_daily_total.update(total_calories_out: old_daily_total.total_calories_out - old_activity.calories_burned, net_calories: old_daily_total.net_calories + old_activity.calories_burned)
        new_daily_total.update(total_calories_out: new_daily_total.total_calories_out + self.calories_burned, net_calories: new_daily_total.net_calories - self.calories_burned)
      end
    end
  end

end