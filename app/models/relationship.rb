class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  # before_save :update_following_each_other

  # def blocked?
  #   self.blocked
  # end

  # def following_each_other?
  #   self.following_each_other
  # end

  # def update_following_each_other
  #   if !blocked? && Relationship.find_by(follower: self.followee, followee: self.follower) 
      
  #   else
      
  #   end
  # end
end
