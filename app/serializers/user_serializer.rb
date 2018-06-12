class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :daily_calorie_intake_goal, :quote
end
