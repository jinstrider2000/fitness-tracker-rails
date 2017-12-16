class AchievementPolicy < ApplicationPolicy

  def show?
    !user.blocked_by?(record.user)
  end

  def index?
    show?
  end

  def create?
    record.user_id == user.id
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
  
end