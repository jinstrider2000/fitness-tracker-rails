class AchievementPolicy < ApplicationPolicy

  def create?
    record.user_id == user.id
  end

  def show?
    !user.blocked_by?(record.user)
  end

  def update?
    user.id == record.user.id
  end

  def destroy?
    update?
  end
  
end