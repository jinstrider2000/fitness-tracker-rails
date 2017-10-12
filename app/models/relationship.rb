class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  before_save :update_following_each_other
  after_destroy :falsify_following_each_other_on_reciprocal, if: :reciprocal_exists?

  def block
    reciprocal_relationship = get_reciprocal_relationship
    reciprocal_relationship.destroy if self.update(blocked: true, following_each_other: false) && reciprocal_relationship.present? 
  end

  def unblock
    self.destroy
  end

  private

  def update_following_each_other
    if !self.blocked?
      reciprocal_relationship = get_reciprocal_relationship
      if reciprocal_relationship.present?
        if !self.following_each_other?
          self.following_each_other = true
          reciprocal_relationship.update_column(:following_each_other, true)
        end
      elsif self.following_each_other?
        self.following_each_other = false
        reciprocal_relationship.update_column(:following_each_other, false)
      end
    end
  end

  def get_reciprocal_relationship
    Relationship.find_by(follower: self.followee, followee: self.follower)
  end

  def falsify_following_each_other_on_reciprocal
    get_reciprocal_relationship.update(following_each_other: false)
  end

  def reciprocal_exists?
    !!get_reciprocal_relationship
  end
end
