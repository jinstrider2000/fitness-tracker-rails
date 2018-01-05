class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followee
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :blocked_relationships, class_name: "Block", dependent: :destroy
  has_many :blocked_users, through: :blocked_relationships
  has_many :muted_relationships, class_name: "Mute", dependent: :destroy
  has_many :muted_users, through: :muted_relationships
  has_many :achievements, dependent: :destroy
  has_many :exercises, -> {where(activity_type: "Exercise")}, class_name: "Achievement"
  has_many :foods, -> {where(activity_type: "Food")}, class_name: "Achievement"
  has_many :daily_totals, dependent: :destroy

  validates_presence_of :name, :daily_calorie_intake_goal, :email
  validates :email, uniqueness: true
  validates :daily_calorie_intake_goal, numericality: {greater_than_or_equal_to: 1}
  
  after_create :update_slug_column
  before_save :set_slug, on: :update, unless: :slug_set_properly? 

  def first_name
    self.name.split(" ")[0]
  end

  def recent_achievements(activity_type = nil)
    if activity_type.present? && Achievement.valid_activity?(activity_type.capitalize)
      self.send(activity_type.downcase.pluralize).order(id: :desc).limit(6)
    else
      self.achievement.order(id: :desc).limit(6)
    end
  end

  def achievements_ordered_by(activity_type = nil, filter = nil, order = nil)
    if Achievement.valid_activity?(activity_type)
      valid_filters = activity_type.capitalize.constantize.valid_filter_options
    else
      valid_filters = Achievement.valid_filter_options
    end
    if filter.try(:downcase) != "completed on" && Achievement.valid_activity?(activity_type) && valid_filters.any? {|valid_filter| valid_filter.downcase == filter.try(:downcase)}
      valid_filter = filter.downcase.gsub(" ", "_").to_sym
      achievement = Achievement.arel_table
      user = User.arel_table
      activity = activity_type.capitalize.constantize.arel_table
      query = achievement.join(activity).on(achievement[:activity_id].eq(activity[:id])).where(achievement[:activity_type].eq(activity_type.capitalize).and(achievement[:user_id].eq(self.id))).project(Arel.sql('*'))
      order.try(:downcase) == "ascending" ? Achievement.find_by_sql(query.order(activity[valid_filter].asc)) : Achievement.find_by_sql(query.order(activity[valid_filter].desc))
    else
      if Achievement.valid_activity?(activity_type)
        dates_array = (order.try(:downcase) == "ascending" ? self.send(activity_type.pluralize.downcase).distinct.order(completed_on: :asc).pluck(:completed_on) : self.send(activity_type.pluralize.downcase).distinct.order(completed_on: :desc).pluck(:completed_on))
        achievement = Achievement.arel_table
        [].tap do |array|
          dates_array.each_slice(3) do |date_array|
            date_row = []
            date_array.each do |date|
              date_row << self.send(activity_type.downcase.pluralize).where(achievement[:completed_on].eq(date))
            end
            array << date_row
          end
        end
      else
        dates_array = (order.try(:downcase) == "ascending" ? self.daily_totals.order(completed_on: :asc).pluck(:completed_on) : self.daily_totals.order(completed_on: :desc).pluck(:completed_on))
        [].tap do |array|
          dates_array.each_slice(3) do |date_array|
            date_row = []
            date_array.each do |date|
              date_row << self.achievements.where(completed_on: date)
            end
            array << date_row
          end
        end
      end
    end
  end

  def achievement_following_timeline
    timeline_user_ids = [self.id, self.following.distinct.pluck(:id)].flatten
    Achievement.where(user_id: timeline_user_ids).order(updated_at: :desc)
  end

  def blocked?(user)
    !!self.blocked_users.find_by(id: user.id)
  end

  def blocked_by?(user)
    user.blocked?(self)
  end

  def block(user)
    self.unfollow(user) if self.following?(user)
    find_follower_relationship_with(user).destroy if self.follower?(user)
    self.blocked_relationships.build(blocked_user: user)
    self.save
  end

  def unblock(user)
    find_blocked_relationship_with(user).destroy
  end

  def muted?(user)
    !!find_muted_relationship_with(user)
  end

  def mute(user)
    self.muted_relationships.build(muted_user: user)
    self.save
  end

  def unmute(user)
    find_muted_relationship_with(user).destroy
    self.save
  end

  def following?(user)
    !!find_following_relationship_with(user)
  end

  def follower?(user)
    !!find_follower_relationship_with(user)
  end

  def follow(user)
    self.following_relationships.build(followee: user)
    self.save
  end

  def unfollow(user)
    find_following_relationship_with(user).destroy
  end

  private

  def slug_set_properly?
    self.id != nil && self.slug == get_proper_slug
  end

  def get_proper_slug
    "#{self.id}-#{CGI.escape(self.name.downcase).gsub("+","-")}"
  end

  def update_slug_column
    self.update_column(:slug, get_proper_slug)
  end

  def set_slug
    self.slug = get_proper_slug
  end

  def find_follower_relationship_with(user)
    self.follower_relationships.find_by(follower: user)
  end

  def find_following_relationship_with(user)
    self.following_relationships.find_by(followee: user)
  end

  def find_blocked_relationship_with(user)
    self.blocked_relationships.find_by(blocked_user: user)
  end

  def find_muted_relationship_with(user)
    self.muted_relationships.find_by(muted_user: user)
  end

end
