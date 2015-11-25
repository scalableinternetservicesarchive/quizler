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

  def cache_key_for_user_search_results_table(query_username, page)
    max_updated_at = "#{Friendship.maximum(:updated_at)}-#{User.maximum(:updated_at)}"
    "friendships/search_result/table/#{query_username}/#{max_updated_at}/#{page}"
  end

  def cache_key_for_user_search_results_row(search_result)
    "friendships/search_result/row/#{search_result.username}/#{search_result.user_updated_at}/#{search_result.friendship_updated_at}"
  end

end
