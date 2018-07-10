class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :slug, :truncated_quote, :truncated_name, :view

  def view
    view_object = {}
    if current_user.following_each_other?(object) 
      view_object[:follow_status] = I18n.t "users.users_helper.follow_status.following_each_other"
    elsif object.following?(current_user) 
      view_object[:follow_status] = I18n.t "users.users_helper.follow_status.follows_you"
    else
      view_object[:follow_status] = ""
    end 
    
    view_object[:show_link] = ApplicationController.helpers.route_helpers.user_path(locale: I18n.locale, slug: object.slug)
    view_object[:profile_pic_path] = ApplicationController.helpers.profile_pic_path(object)
    view_object[:primary_action] = {}

    if current_user.blocked?(object)
      view_object[:primary_action][:name] = :unblock
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :delete
      view_object[:primary_action][:classes] = "btn btn-danger"
    elsif current_user.following?(object)
      view_object[:primary_action][:name] = :unfollow
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :delete
      view_object[:primary_action][:classes] = "btn btn-warning"
    elsif current_user.blocked_by?(object)
      view_object[:primary_action][:name] = :block
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :post
      view_object[:primary_action][:classes] = "btn btn-danger"
    else
      view_object[:primary_action][:name] = :follow
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :post
      view_object[:primary_action][:classes] = "btn btn-success"
    end

    view_object[:secondary_action] = []

    if view_object[:primary_action][:name] == :follow || view_object[:primary_action][:name] == :unfollow
      view_object[:secondary_action] << {:name => :block, :locale_name => User.human_attribute_name(:block), :method => :post}
      if current_user.muted?(object)
        view_object[:secondary_action] << {:name => :unmute, :locale_name => User.human_attribute_name(:unmute), :method => :delete}
      else
        view_object[:secondary_action] << {:name => :mute, :locale_name => User.human_attribute_name(:mute),:method => :post}
      end
    end
    view_object
  end
  
end
