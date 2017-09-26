class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :achievements
  has_many :exercises, through: :achievements, source: :activity, source_type: "Exercise"
  has_many :foods, through: :achievements, source: :activity, source_type: "Food"
  validates_presence_of :username, :name, :daily_calorie_goal
  validates :username, uniqueness: true
  validates :daily_calorie_goal, numericality: {greater_than_or_equal_to: 1}

  def first_name
    self.name.split(" ")[0]
  end
end
