class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  validates_presence_of :activity, :user

  def activity_attributes=(values)
    if values.key?(:calories_burned)
      self.activity = Exercise.new(values)
    else
      self.activity = Food.new(values)
    end
  end
end
