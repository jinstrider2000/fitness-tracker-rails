class Exercise < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Date", "Name", "Calories Burned"]
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"]

  has_one :achievement, as: :activity, dependent: :destroy
  validates_presence_of :name, :calories_burned
  validates :calories_burned, numericality: {greater_than_or_equal_to: 1}
  accepts_nested_attributes_for :achievement, update_only: true, reject_if: proc {|attributes| attributes.any? {|attr, val| attr != 'completed_on'}}

  before_update :update_daily_total, on: :update

  extend FitnessTracker::SortableActivity

  private

  include FitnessTracker::DailyTotalUpdatable

end
