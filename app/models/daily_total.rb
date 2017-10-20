class DailyTotal < ApplicationRecord
  belongs_to :user
  validates_presence_of :user

  def self.find_daily_total_for(user,activity)
    arel = self.arel_table
    self.find_by(arel[:user_id].eq(user.id).and(arel[:created_at].gteq(activity.created_at.beginning_of_day).and(arel[:created_at].lteq(activity.created_at.end_of_day))))
  end

end
