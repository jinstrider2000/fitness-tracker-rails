class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  before_save :update_following_each_other

  private

  def update_following_each_other
    reciprocal_relationship = Relationship.find_by(follower: self.followee, followee: self.follower)
    if !self.blocked? && reciprocal_relationship.present?
      self.following_each_other = true
    else
      self.following_each_other = false
    end
  end
end
