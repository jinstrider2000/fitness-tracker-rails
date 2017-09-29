class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  validates_presence_of :activity

  def activity_attributes=(values)
    
  end
end
