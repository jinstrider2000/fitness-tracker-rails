class DailyTotal < ApplicationRecord
  belongs_to :user
  validates_presence_of :user

  def self.find_daily_total_for(user,activity)
    arel = self.arel_table
    self.find_by(arel[:user_id].eq(user.id).and(arel[:completed_on].eq(activity.completed_on)))
  end

end
