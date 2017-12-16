class UserPolicy < ApplicationPolicy

    def followers?
      index?
    end
  
    def following?
      index?
    end
  
    def blocked?
      user.id == record.id
    end
  
    def muted?
      blocked?
    end
  
    def follow?
      user.id != record.id && !user.following?(record) && !user.blocked?(record) && !user.blocked_by?(record)
    end
  
    def unfollow?
      user.id != record.id && user.following?(record) && !user.blocked?(record) && !user.blocked_by?(record)
    end
  
    def block?
      user.id != record.id && !user.blocked?(record)
    end
  
    def unblock?
      user.id != record.id && user.blocked?(record)
    end
  
    def mute?
      user.id != record.id && !user.muted?(record)
    end
  
    def unmute?
      user.id != record.id && user.muted?(record)
    end
    
  end