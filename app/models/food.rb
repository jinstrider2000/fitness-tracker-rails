class Food < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Date", "Name", "Calories"]
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"]

  has_one :achievement, as: :activity
  validates_presence_of :name, :calories
  validates :calories, numericality: {greater_than_or_equal_to: 0}

  extend FitnessTracker::SortableActivity

end