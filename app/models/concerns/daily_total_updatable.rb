module DailyTotalUpdatable

  def update_daily_total
    daily_total = DailyTotal.find_daily_total_for(self.achievement.user,self)
    old_record = self.class.find_by(id: self.id)
    if self.class.to_s == "Food"
      daily_total.update(total_calories_in: daily_total.total_calories_in - old_record.calories + self.calories, net_calories: daily_total.net_calories - old_record.calories + self.calories)
    else
      daily_total.update(total_calories_out: daily_total.total_calories_out + old_record.calories_burned - self.calories_burned, net_calories: daily_total.net_calories + old_record.calories_burned - self.calories_burned)
    end
  end

end