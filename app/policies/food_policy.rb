class FoodPolicy < ApplicationPolicy

  def index?
    user.blocked_by?(record)
  end

  def show?
    user.blocked_by?(record.achievement.user)
  end

  def update?
    user.id == record.achievement.user.id
  end

  def destroy?
    update?
  end
  
end