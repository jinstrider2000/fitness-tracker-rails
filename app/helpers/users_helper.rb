module UsersHelper

  def action_button(user)
    if current_user.blocked?(user)
      primary_action = [:unblock, :delete]
      primary_btn_classes = %w[btn btn-danger]
    elsif current_user.following?(user)
      primary_action = [:unfollow, :delete]
      primary_btn_classes = %w[btn btn-warning]
    else
      primary_action = [:follow, :post]
      primary_btn_classes = %w[btn btn-success]
    end

    if primary_action.first == :unblock
      secondary_actions = []
    else
      secondary_actions = [[:block, :post], current_user.muted?(user) ? [:unmute, :delete] : [:mute, :post]]
    end
    render partial: 'action_btn', locals: {primary_action: primary_action, secondary_actions: secondary_actions, primary_btn_classes: primary_btn_classes, user: user}
  end

end
