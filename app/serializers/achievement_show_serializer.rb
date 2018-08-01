class AchievementShowSerializer < ActiveModel::Serializer
  attributes :id, :comment, :activity_type, :view
  belongs_to :user
  belongs_to :activity, polymorphic: false

  def view
    view_object = {}
    if object.user.id == view_context.current_user.id
      view_object[:heading] = view_context.t("achievements.show.my_heading", record_name: object.activity.model_name.human)
    else
      view_object[:heading] = view_context.t("achievements.show.other_user_heading", record_name: object.activity.model_name.human, user_name: object.user.first_name)
    end
    view_object[:title] = view_context.t "achievements.show.title", user_name: object.user.first_name, record_name: object.activity.name
    view_object[:activity_icon_src] = view_context.asset_path "#{object.activity_type.downcase}_icon", type: :image
    view_object[:completed_on] = view_context.print_date(object.completed_on)
    view_object[:ach_show_link] = view_context.render(partial: "#{object.activity_type.downcase}.html", locals: {object.activity_type.downcase.to_sym => object})
    view_object
  end

end
