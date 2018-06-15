class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :profile_pic
  attr_readonly :profile_pic_url, :provider, :uid

  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

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
  validates :name, length: {maximum: 20}
  validates :email, uniqueness: true
  validates :daily_calorie_intake_goal, numericality: {greater_than_or_equal_to: 1}
  validates :quote, length: {maximum: 145}
  validate :profile_pic_is_valid_if_present
  
  after_create :update_slug_column
  after_create_commit :save_profile_pic
  before_update :set_slug, unless: :slug_set_properly?
  before_update :override_profile_pic_change, if: [:new_profile_pic_present?, :remote_pic_chosen?]
  after_update_commit :update_profile_pic, if: :new_profile_pic_present?
  after_destroy_commit :delete_image_dir

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

  def truncated_quote(size: 60, sep: " ")
    self.quote.truncate(size, separator: sep)
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
        dates_array = (order.try(:downcase) == "ascending" ? self.send(activity_type.pluralize.downcase).group(:completed_on).order(completed_on: :asc).pluck(:completed_on) : self.send(activity_type.pluralize.downcase).group(:completed_on).order(completed_on: :desc).pluck(:completed_on))
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

  def news_feed_items(latest_post_created = nil)
    news_feed_user_ids = [self.id, self.following.pluck(:id)].flatten - self.muted_users.pluck(:id)
    if latest_post_created == nil
      Achievement.where(user_id: news_feed_user_ids).order(created_at: :desc)
    else
      achievements = Achievement.arel_table
      Achievement.where(achievements[:user_id].in(news_feed_user_ids).and(achievements[:created_at].gt(latest_post_created))).order(created_at: :desc)
    end
  end

  def blocked?(user)
    !!self.blocked_users.find_by(id: user.id)
  end

  def blocked_by?(user)
    user.blocked?(self)
  end

  def block(user)
    self.unfollow(user)
    find_follower_relationship_with(user).try(:destroy)
    self.unmute(user)
    self.blocked_relationships.build(blocked_user: user)
    self.save
  end

  def unblock(user)
    find_blocked_relationship_with(user).try(:destroy)
  end

  def muted?(user)
    !!find_muted_relationship_with(user)
  end

  def mute(user)
    self.muted_relationships.build(muted_user: user)
    self.save
  end

  def unmute(user)
    find_muted_relationship_with(user).try(:destroy)
  end

  def following_each_other?(user)
    !!find_following_relationship_with(user).try(:following_each_other)
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
    find_following_relationship_with(user).try(:destroy)
  end

  def get_length_validation_options_for(attr)
    self._validators[attr.to_sym].find {|validator| validator.kind == :length}.options
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = "password123"
      user.name = auth.info.name   # assuming the user model has a name
      user.profile_pic_url = auth.info.image
      user.remote_profile_pic = true
      user.daily_calorie_intake_goal = 2000
      user.quote = "Have a great day!"
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.most_active_today
    achievement = Achievement.arel_table
    stats = User.joins(:achievements).where(achievement[:created_at].gteq(DateTime.now.beginning_of_day).and(achievement[:created_at].lteq(DateTime.now.end_of_day))).group(:id).count.sort_by{|key,value| -value}.first
    if stats.present?
      user_and_achievement_amt = [User.find_by(id: stats[0]), stats[1]]
    else
      []
    end
  end

  private

  def slug_set_properly?
    self.id != nil && self.slug == get_proper_slug
  end

  def get_proper_slug
    "#{self.id}-#{CGI.escape(self.name.downcase.gsub(/[^\w ]/,"")).gsub("+","-")}"
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

  def profile_pic_is_valid_if_present
    if self.profile_pic.present? && !(self.profile_pic.content_type =~ /image/)
      self.errors.add :profile_pic, :invalid_file_type
    end
  end

  def save_profile_pic
    FitnessTracker::ImageSaver.new(self).save_profile_pic(self.profile_pic)
  end

  def update_profile_pic
    FitnessTracker::ImageSaver.new(self).update_profile_pic(self.profile_pic)
  end

  def delete_image_dir
    FitnessTracker::ImageSaver.new(self).delete_user_image_dir
  end

  def new_profile_pic_present?
    self.profile_pic.present?
  end

  def remote_pic_chosen?
    self.provider.present? && self.remote_profile_pic
  end

  def override_profile_pic_change
    self.profile_pic = nil
  end

end
