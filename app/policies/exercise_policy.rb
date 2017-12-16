class ExercisePolicy < ApplicationPolicy

  def show?
    !user.blocked_by?(record.achievement.user)
  end

  def index?
    show?
  end

  def update?
    user.id == record.achievement.user.id
  end

  def destroy?
    update?
  end
  
end