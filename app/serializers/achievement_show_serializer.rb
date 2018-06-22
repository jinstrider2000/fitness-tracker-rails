class AchievementShowSerializer < ActiveModel::Serializer
  attributes :id, :comment, :activity_type, :view
  belongs_to :user
  belongs_to :activity, polymorphic: false

  def view
    view_object = {}
    if object.user.id == current_user.id
      view_object[:heading] = I18n.t("achievements.show.my_heading", record_name: object.activity.model_name.human)
    else
      view_object[:heading] = I18n.t("achievements.show.other_user_heading", record_name: object.activity.model_name.human, user_name: object.user.first_name)
    end
    view_object[:title] = I18n.t "achievements.show.title", user_name: object.user.first_name, record_name: object.activity.name
    view_object[:activity_icon_src] = ApplicationController.helpers.asset_path "#{object.activity_type.downcase}_icon", type: :image
    view_object[:completed_on] = ApplicationController.helpers.print_date(object.completed_on)
    view_object
  end

end
