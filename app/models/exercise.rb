class Exercise < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Completed On", "Name", "Calories Burned"]
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"]

  has_one :achievement, as: :activity
  validates_presence_of :name, :calories_burned
  validates :calories_burned, numericality: {greater_than_or_equal_to: 1}

  extend FitnessTracker::SortableActivity

end
