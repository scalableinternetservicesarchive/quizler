module FriendshipsHelper

  def add_friend_button(user)
    value_button = 'Add Friend'
    options = {
        data: {path: friends_create_path, id: user.id} ,
        class: 'js-add-friend-btn',
    }

    if current_user.pending_friend?(user)
      value_button = 'Friend request sent'
      options[:disabled] = true
    elsif current_user.friends?(user)
      value_button = 'Friend'
      options[:disabled] = true
    end

    button_tag value_button, options
  end
end
