# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)      default(""), not null
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'a user should have an username and an email' do
    user = User.new(username: 'whatever', email: 'hello@ucsb.edu', password: 'password')
    assert user.valid?

    user = User.new(username: '', email: 'hello@ucsb.edu', password: 'password')
    assert !user.valid?
    assert_equal ['Username can\'t be blank'], user.errors.full_messages

    user = User.new(username: 'whatever', email: '', password: 'password')
    assert !user.valid?
    assert_equal ['Email can\'t be blank'], user.errors.full_messages
  end

  test 'the email should be formatted correctly' do
    user = User.new(username: 'whatever', email: 'hello@ucsb.edu', password: 'password')
    assert user.valid?

    user = User.new(username: 'whatever', email: 'helloucsb.edu', password: 'password')
    assert !user.valid?
    assert_equal ['Email is invalid'], user.errors.full_messages

    user = User.new(username: 'whatever', email: 'hello@ucsbedu', password: 'password')
    assert !user.valid?
    assert_equal ['Email is invalid'], user.errors.full_messages
  end

  test 'the friendship is bidirectional' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')

    assert_equal 0, user_1.friends.count
    assert_equal 0, user_1.inverse_friends.count
    assert_equal 0, user_2.friends.count
    assert_equal 0, user_2.inverse_friends.count

    user_1.friends << user_2
    user_1.save!

    user_2.reload
    assert_equal user_2, user_1.friends.first
    assert_equal user_1, user_2.inverse_friends.first
  end

  test 'username is unique' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.new(username: 'user1', email: 'user2@ucsb.edu', password: 'password')

    assert !user_2.valid?
    assert_equal ['Username has already been taken'], user_2.errors.full_messages
  end

  test 'get_friends_and_pending_friends should return friends and pending friends' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')
    user_4 = User.create(username: 'user4', email: 'user4@ucsb.edu', password: 'password')
    user_5 = User.create(username: 'user5', email: 'user5@ucsb.edu', password: 'password')

    Friendship.create(user: user_1, friend: user_2, accepted_at: DateTime.now)
    Friendship.create(user: user_1, friend: user_3)
    Friendship.create(user: user_4, friend: user_1, accepted_at: DateTime.now)
    Friendship.create(user: user_5, friend: user_1)

    assert_equal [user_2, user_3, user_4, user_5], user_1.get_friends_and_pending_friends
  end

  test 'get_friends should return only the friends' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')
    user_4 = User.create(username: 'user4', email: 'user4@ucsb.edu', password: 'password')
    user_5 = User.create(username: 'user5', email: 'user5@ucsb.edu', password: 'password')

    Friendship.create(user: user_1, friend: user_2, accepted_at: DateTime.now)
    Friendship.create(user: user_1, friend: user_3)
    Friendship.create(user: user_4, friend: user_1, accepted_at: DateTime.now)
    Friendship.create(user: user_5, friend: user_1)

    assert_equal [user_2, user_4], user_1.get_friends
  end

  test 'get_pending_friends should return only the pending friends' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')
    user_4 = User.create(username: 'user4', email: 'user4@ucsb.edu', password: 'password')
    user_5 = User.create(username: 'user5', email: 'user5@ucsb.edu', password: 'password')

    Friendship.create(user: user_1, friend: user_2, accepted_at: DateTime.now)
    Friendship.create(user: user_1, friend: user_3)
    Friendship.create(user: user_4, friend: user_1, accepted_at: DateTime.now)
    Friendship.create(user: user_5, friend: user_1)

    assert_equal [user_3, user_5], user_1.get_pending_friends
  end

  test 'pending_friend? should return true if the other user is a pending friend otehrwise false' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')

    Friendship.create(user: user_1, friend: user_2, accepted_at: DateTime.now)
    Friendship.create(user: user_1, friend: user_3)

    assert !user_1.pending_friend?(user_2)
    assert user_1.pending_friend?(user_3)
    assert !user_2.pending_friend?(user_3)
  end

  test 'friends? should return true if the other user is a  friend otherwise false' do
    user_1 = User.create(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'user3', email: 'user3@ucsb.edu', password: 'password')

    Friendship.create(user: user_1, friend: user_2, accepted_at: DateTime.now)
    Friendship.create(user: user_1, friend: user_3)

    assert user_1.friends?(user_2)
    assert !user_1.friends?(user_3)
    assert !user_2.friends?(user_3)
  end

  test 'search_user returns list of users containing matching characters specified in username input' do
    user_1 = User.create(username: 'francois1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'francois2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'franck', email: 'user3@ucsb.edu', password: 'password')
    user_4 = User.create(username: 'francoise', email: 'user4@ucsb.edu', password: 'password')
    user_5 = User.create(username: 'francis', email: 'user5@ucsb.edu', password: 'password')
    user_6 = User.create(username: 'stephan', email: 'user6@ucsb.edu', password: 'password')

    assert_equal [user_2, user_3, user_4, user_5], User.search_user('fra', user_1).to_a
    assert_equal [user_2, user_4], User.search_user('franco', user_1).to_a
    assert_equal [user_2, user_4, user_5, user_6], User.search_user('s', user_1).to_a
    assert_equal [user_1, user_4], User.search_user('franco', user_2).to_a
  end
end
