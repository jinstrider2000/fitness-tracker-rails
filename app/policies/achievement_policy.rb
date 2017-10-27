class AchievementPolicy < ApplicationPolicy

  def create?
    record.user_id == user.id
  end

  def index?
    user.blocked_by?(record)
  end
  
end