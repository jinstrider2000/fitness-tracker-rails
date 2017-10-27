class UserPolicy < ApplicationPolicy

    def followers?
      !user.blocked_by?(record)
    end
  
    def following?
      !user.blocked_by?(record)
    end
  
    def blocked?
      !user.blocked_by?(record)
    end
  
    def muted?
      !user.blocked_by?(record)
    end
  
    def follow?
      !user.following?(record) && !user.blocked?(record) && !user.blocked_by?(record)
    end
  
    def unfollow?
      user.following?(record) && !user.blocked?(record) && !user.blocked_by?(record)
    end
  
    def block?
      !user.blocked?(record)
    end
  
    def unblock?
      user.blocked?(record)
    end
  
    def mute?
      !user.muted?(record)
    end
  
    def unmute?
      user.muted?(record)
    end
    
  end