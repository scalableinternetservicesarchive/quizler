module FriendshipsHelper

  def add_friend_button(search_user_result)
    value_button = 'Add Friend'
    options = {
        data: {path: friends_path, id: search_user_result.id} ,
        class: 'js-add-friend-btn',
    }

    if search_user_result.pending_friend?
      value_button = 'Friend request sent'
      options[:disabled] = true
    elsif search_user_result.friends?
      value_button = 'Friend'
      options[:disabled] = true
    elsif search_user_result.incoming_pending_friend?
      value_button = 'Received Friend request'
      options[:disabled] = true
    end

    button_tag value_button, options
  end

  def number_friend_requests_text(pending_friendships)
    pluralize(pending_friendships.count, 'friend request')
  end
end
