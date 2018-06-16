class AchievementPolicy < ApplicationPolicy

  def show?
    create? || !user.blocked_by?(record.user) && !user.blocked?(record.user)
  end

  def index?
    show?
  end

  def next?
    show?
  end

  def prev?
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