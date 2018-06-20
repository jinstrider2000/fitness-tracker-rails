class AchievementSerializer < ActiveModel::Serializer
  attributes :id, :completed_on, :activity_type, :activity, :comment
  belongs_to :user
end
