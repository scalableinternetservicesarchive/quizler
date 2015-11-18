require 'test_helper'

class FriendshipsHelperTest < ActionView::TestCase

  setup do
    @current_user = User.create(username: 'user0', email: 'user0@ucsb.edu', password: 'password')
  end

  def current_user
    @current_user
  end

  def test_add_friend_button
    other_user = User.create!(username: 'user1', email: 'user1@ucsb.edu', password: 'password')

    users_joined_with_friendships = User.search_users(@current_user, 'user1')
    search_user_result = SearchUserResult.new(@current_user, users_joined_with_friendships.first)

    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends" name="button" type="submit">Add Friend</button>'
    assert_equal expected_result, add_friend_button(search_user_result)

    @current_user.friends << other_user
    users_joined_with_friendships = User.search_users(@current_user, 'user1')
    search_user_result = SearchUserResult.new(@current_user, users_joined_with_friendships.first)

    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends" disabled="disabled" name="button" type="submit">Friend request sent</button>'
    assert_equal expected_result, add_friend_button(search_user_result)

    @current_user.friendships.last.update_attributes(accepted_at: DateTime.now)
    users_joined_with_friendships = User.search_users(@current_user, 'user1')
    search_user_result = SearchUserResult.new(@current_user, users_joined_with_friendships.first)

    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends" disabled="disabled" name="button" type="submit">Friend</button>'
    assert_equal expected_result, add_friend_button(search_user_result)
  end

  def test_number_friend_requests_text
    user_1 = User.create!(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create!(username: 'user2', email: 'user2@ucsb.edu', password: 'password')

    friendship_1 = Friendship.create!(user: user_1, friend: @current_user)
    friendship_2 = Friendship.create!(user: user_2, friend: @current_user)

    friendships = [friendship_1]

    assert_equal '0 friend requests', number_friend_requests_text([])
    assert_equal '1 friend request', number_friend_requests_text(friendships)

    friendships << friendship_2
    assert_equal '2 friend requests', number_friend_requests_text(friendships)
  end
end
