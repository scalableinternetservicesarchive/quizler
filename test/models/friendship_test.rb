require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  setup do
    @user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    @user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    @user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')
    @user_4 = User.create(username: 'user4', email: 'user4@ucsb.edu', password: 'password')
    @user_5 = User.create(username: 'user5', email: 'user5@ucsb.edu', password: 'password')

    @friendship_1 = Friendship.create(user: @user_1, friend: @user_2, accepted_at: DateTime.now)
    @friendship_2 = Friendship.create(user: @user_1, friend: @user_3)
    @friendship_3 = Friendship.create(user: @user_4, friend: @user_1, accepted_at: DateTime.now)
    @friendship_4 = Friendship.create(user: @user_5, friend: @user_1)
  end

  test 'self.get_friendships_including_pending' do
    assert_equal [@friendship_1, @friendship_2, @friendship_3, @friendship_4], Friendship.get_friendships_including_pending(@user_1)
  end

  test 'self.get_friends' do
    assert_equal [@friendship_1, @friendship_3], Friendship.get_friends(@user_1)
  end

  test 'self.get_pending_friends' do
    assert_equal [@friendship_2, @friendship_4], Friendship.get_pending_friends(@user_1)
  end

  test 'self.get_friendship' do
    assert_equal @friendship_1, Friendship.get_friendship(@user_1, @user_2)
    assert_equal @friendship_2, Friendship.get_friendship(@user_1, @user_3)
    assert_equal @friendship_3, Friendship.get_friendship(@user_1, @user_4)
    assert_equal @friendship_4, Friendship.get_friendship(@user_1, @user_5)
  end

  test 'validation_uniqueness_of_friendship' do
    user_a = User.create(username: 'userA', email: 'userA@ucsb.edu', password: 'password')
    user_b = User.create(username: 'userB', email: 'userB@ucsb.edu', password: 'password')

    valid_friendship = Friendship.create(user: user_a, friend: user_b)

    invalid_friendship = Friendship.create(user: user_a, friend: user_b)

    assert !invalid_friendship.valid?
    assert_equal ['Friendship already exists'], invalid_friendship.errors.full_messages

    # Make sure that we can update an existing friendship
    valid_friendship.accepted_at = DateTime.now
    assert valid_friendship.valid?
  end

end
