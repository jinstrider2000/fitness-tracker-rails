class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :slug, :truncated_quote, :truncated_name, :view

  def view
    view_object = {}
    if view_context.current_user.following_each_other?(object) 
      view_object[:follow_status] = view_context.t "users.users_helper.follow_status.following_each_other"
    elsif object.following?(view_context.current_user) 
      view_object[:follow_status] = view_context.t "users.users_helper.follow_status.follows_you"
    else
      view_object[:follow_status] = ""
    end
    
    view_object[:show_link] = view_context.route_helpers.user_path(locale: view_context.locale, slug: object.slug)
    view_object[:profile_pic_path] = view_context.profile_pic_path(object)
    view_object[:primary_action] = {}

    if view_context.current_user.blocked?(object)
      view_object[:primary_action][:name] = :unblock
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :delete
      view_object[:primary_action][:classes] = "btn btn-danger"
    elsif view_context.current_user.following?(object)
      view_object[:primary_action][:name] = :unfollow
      view_object[:primary_action][:locale_name] = User.human_attribute_name(view_object[:primary_action][:name])
      view_object[:primary_action][:method] = :delete
      view_object[:primary_action][:classes] = "btn btn-warning"
    elsif view_context.current_user.blocked_by?(object)
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
      view_object[:secondary_action] << {:name => :block, :locale_name => "#{User.human_attribute_name(:block)} #{object.first_name}", :method => :post}
      if view_context.current_user.muted?(object)
        view_object[:secondary_action] << {:name => :unmute, :locale_name => "#{User.human_attribute_name(:unmute)} #{object.first_name}", :method => :delete}
      else
        view_object[:secondary_action] << {:name => :mute, :locale_name => "#{User.human_attribute_name(:mute)} #{object.first_name}",:method => :post}
      end
    end
    view_object
  end
  
end
