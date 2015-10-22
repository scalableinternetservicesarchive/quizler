require 'test_helper'

class FriendshipsHelperTest < ActionView::TestCase

  setup do
    @current_user = User.create(username: 'user0', email: 'user0@ucsb.edu', password: 'password')
  end

  def current_user
    @current_user
  end

  def test_add_friend_button
    other_user = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')

    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends/create" name="button" type="submit">Add Friend</button>'
    assert_equal expected_result, add_friend_button(other_user)

    @current_user.friends << other_user
    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends/create" disabled="disabled" name="button" type="submit">Friend request sent</button>'
    assert_equal expected_result, add_friend_button(other_user)

    @current_user.friendships.last.update_attributes(accepted_at: DateTime.now)
    expected_result = '<button class="js-add-friend-btn" data-id="2" data-path="/friends/create" disabled="disabled" name="button" type="submit">Friend</button>'
    assert_equal expected_result, add_friend_button(other_user)
  end
end
