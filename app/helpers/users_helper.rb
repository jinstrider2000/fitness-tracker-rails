module UsersHelper

  def action_button(user)
    if current_user.blocked?(user)
      primary_action = [:unblock, :delete]
      primary_btn_classes = %w[btn btn-danger]
    elsif current_user.following?(user)
      primary_action = [:unfollow, :delete]
      primary_btn_classes = %w[btn btn-warning]
    elsif current_user.blocked_by?(user)
      primary_action = [:block, :post]
      primary_btn_classes = %w[btn btn-danger]
    else
      primary_action = [:follow, :post]
      primary_btn_classes = %w[btn btn-success]
    end

    if primary_action.first == :unblock || primary_action.first == :block
      secondary_actions = []
    else
      secondary_actions = [[:block, :post], current_user.muted?(user) ? [:unmute, :delete] : [:mute, :post]]
    end
    render partial: 'action_btn', locals: {primary_action: primary_action, secondary_actions: secondary_actions, primary_btn_classes: primary_btn_classes, user: user}
  end

  def follow_status(user, options={})
    # classes = %w[follow-status-msg]
    # classes << options[:additional_classes]
    # classes.flatten!
    if current_user.following_each_other?(user) 
     tag.span t("users.users_helper.follow_status.following_each_other"), options 
    elsif user.following?(current_user) 
     tag.span t("users.users_helper.follow_status.follows_you"), options 
    end 
  end

end
