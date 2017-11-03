class Exercise < ApplicationRecord
  has_one :achievement, as: :activity, dependent: :destroy
  validates_presence_of :name, :calories_burned, :completed_on
  validates :calories_burned, numericality: {greater_than_or_equal_to: 1}
  before_update :update_daily_total, on: :update

  private

  include DailyTotalUpdatable

end
