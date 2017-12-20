class Achievement < ApplicationRecord

  VALID_FILTER_OPTIONS = ["Date"].freeze
  VALID_ORDER_OPTIONS = ["Descending", "Ascending"].freeze
  VALID_ACTIVITIES = ["Food", "Exercise"].freeze
  VALID_ACTIVITY_PARAMS = {
    [:name, :calories_burned].sort => "Exercise",
    [:name, :calories ].sort => "Food"
  }.freeze

  belongs_to :activity, polymorphic: true, dependent: :destroy
  belongs_to :user
  belongs_to :daily_total
  validates_presence_of :activity, :completed_on, :user, :daily_total

  before_validation :find_or_create_daily_total, on: :create
  after_create :add_to_daily_total
  before_update :update_daily_total

  def activity_attributes=(values)
    klass = VALID_ACTIVITY_PARAMS[values.keys.sort].try(:constantize)
    self.activity = klass.try(:new, values)
    self.activity.try(:achievement=, self)
  end

  def self.valid_activity?(activity_name)
    VALID_ACTIVITIES.any? {|activity| activity == activity_name.try(:capitalize)}
  end

  private

  def find_or_create_daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
  end

  def add_to_daily_total
    DailyTotal::VALID_TOTAL_FORMULAS[__callee__][self.activity.class.to_s].each {|formula| eval formula}
  end

  def update_daily_total
    old_activity = self.activity.class.find_by(id: self.id)
    old_daily_total = self.daily_total
    self.daily_total = DailyTotal.find_or_create_daily_total_for(self)
    new_daily_total = self.daily_total
    DailyTotal::VALID_TOTAL_FORMULAS[__callee__][new_daily_total == old_daily_total][self.activity.class.to_s].each {|formula| eval formula}
  end

end