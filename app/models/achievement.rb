class Achievement < ApplicationRecord
  belongs_to :activity, polymorphic: true
  belongs_to :user
  validates_presence_of :activity
end
