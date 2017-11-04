class Food < ApplicationRecord
  has_one :achievement, as: :activity, dependent: :destroy
  validates_presence_of :name, :calories
  validates :calories, numericality: {greater_than_or_equal_to: 0}
  before_update :update_daily_total, on: :update
  
  private

  include DailyTotalUpdatable

end
