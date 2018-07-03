class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :daily_calorie_intake_goal, :quote, :truncated_quote, :truncated_name
end
