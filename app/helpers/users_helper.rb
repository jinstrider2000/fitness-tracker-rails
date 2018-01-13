module UsersHelper

  def action_button(user)
    if current_user.blocked?(user)
      primary_action = :unblock
    elsif current_user.following?(user)
      primary_action = :unfollow
    else
      primary_action = :follow
    end

    if primary_action == :unblock
      secondary_actions = []
    else
      secondary_actions = [:block, current_user.muted?(user) ? :unmute : :mute]
    end
    render partial: 'action_btn', locals: {primary_action: primary_action, secondary_actions: secondary_actions}
  end

end
