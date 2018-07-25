class NewsFeedIndexSerializer < ActiveModel::Serializer
  attributes :id, :comment, :activity_type, :created_at, :updated_at, :view

  belongs_to :user
  belongs_to :activity, polymorphic: false

  def view
    view_object = {}
    view_object[:activity_icon_src] = view_context.asset_path "#{object.activity_type.downcase}_icon", type: :image
    view_object[:ach_show_link] = view_context.render(partial: "#{object.activity_type.downcase}.html", locals: {object.activity_type.downcase.to_sym => object})
    view_object[:user_show_link] = view_context.route_helpers.user_path(locale: view_context.locale, slug: object.user.slug)
    view_object[:user_profile_pic_path] = view_context.profile_pic_path(object.user)
    view_object[:time_since_created] = view_context.time_since_created(object)
    view_object
  end
end
