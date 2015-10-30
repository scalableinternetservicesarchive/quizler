require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = sign_in_as_user
  end

  test 'search_user action should work' do
    get :search
    assert_response :success
  end

  test 'fetch_users when no username typed in' do
    user_1 = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create!(username: 'Heather', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create!(username: 'Hellofranck', email: 'user3@ucsb.edu', password: 'password')

    xhr :get, :fetch_users, {username: ''}

    assert_response :success
    assert_equal [user_1, user_2, user_3], assigns(:users)

    # expected_response_body = '$(".js-fetched-users").html("    francois - user1@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"2\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Heather - user2@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"3\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Hellofranck - user3@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"4\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n");'
    # assert_equal expected_response_body, response.body
  end

  test 'fetch_users when looking for usernames having same substring' do
    user_1 = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create!(username: 'Heather', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create!(username: 'Hellofranck', email: 'user3@ucsb.edu', password: 'password')

    xhr :get, :fetch_users, {username: 'fran'}

    assert_response :success
    assert_equal [user_1, user_3], assigns(:users)

    # expected_response_body = '$(".js-fetched-users").html("    francois - user1@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"2\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Hellofranck - user3@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"4\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n");'
    # assert_equal expected_response_body, response.body
  end

  test 'create when potential new friend is not found' do
    inexistant_user_id = (User.last.id + 1)

    assert_no_difference 'Friendship.count' do
      xhr :post, :create, {user_id: inexistant_user_id}
    end

    assert_response :success

    jsonResponse = JSON.parse(response.body)
    assert_equal 'error', jsonResponse['status']
    assert_equal 'userInexistant', jsonResponse['errorType']
  end

  test 'create when potential new friend is has already sent request' do
    other_user = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')

    @current_user.friends << other_user
    @current_user.save!

    assert_no_difference 'Friendship.count' do
      xhr :post, :create, {user_id: other_user}
    end

    assert_response :success

    jsonResponse = JSON.parse(response.body)
    assert_equal 'error', jsonResponse['status']
    assert_equal 'cannotSave', jsonResponse['errorType']
    assert_equal other_user.id, jsonResponse['user']
    assert_equal ['Friendship already exists'], jsonResponse['messages']
  end

  test 'create creates a new friendship' do
    other_user = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')

    assert_difference 'Friendship.count', 1 do
      xhr :post, :create, {user_id: other_user}
    end

    assert_response :success

    jsonResponse = JSON.parse(response.body)
    assert_equal 'success', jsonResponse['status']
    assert_equal other_user.id, jsonResponse['user']

    friendship = Friendship.last
    assert_equal @current_user, friendship.user
    assert_equal other_user, friendship.friend
  end

  test 'friendship_requests provides list of pending friend requests' do
    user_1 = User.create!(username: 'user_1', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create!(username: 'user_2', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create!(username: 'user_3', email: 'user3@ucsb.edu', password: 'password')
    user_4 = User.create!(username: 'user_4', email: 'user4@ucsb.edu', password: 'password')
    user_5 = User.create!(username: 'user_5', email: 'user5@ucsb.edu', password: 'password')

    friendship_1 = Friendship.create!(user: user_1, friend: @current_user)
    friendship_2 = Friendship.create!(user: user_2, friend: @current_user, accepted_at: DateTime.now)
    friendship_3 = Friendship.create!(user: user_3, friend: @current_user)
    friendship_4 = Friendship.create!(user: @current_user, friend: user_4)
    friendship_5 = Friendship.create!(user: user_5, friend: @current_user)

    get :friendship_requests

    assert_response :success
    assert_equal [friendship_1, friendship_3, friendship_5], assigns(:incoming_pending_friendships)
  end

  test 'accept_friendship normal case it accepts the friendship' do
    other_user = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    friendship = Friendship.create!(user: other_user, friend: @current_user, accepted_at: nil)

    xhr :post, :accept_friendship, {friendship_id: friendship.id}

    assert_response :success

    friendship.reload

    jsonResponse = JSON.parse(response.body)
    assert_equal 'success', jsonResponse['status']
    assert_equal friendship.id, jsonResponse['friendship']
  end

  test 'accept_friendship when friendship is not found' do
    inexistent_friendship_id = Friendship.last.nil? ? 1 : (Friendship.last.id + 1)

    xhr :post, :accept_friendship, {friendship_id: inexistent_friendship_id}

    assert_response :success

    jsonResponse = JSON.parse(response.body)
    assert_equal 'error', jsonResponse['status']
    assert_equal 'friendshipInexistant', jsonResponse['errorType']
  end

  test 'accept_friendship when friendship already accepted' do
    other_user = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')

    friendship_accepted_at = DateTime.now - 3.day
    friendship = Friendship.create!(user: other_user, friend: @current_user, accepted_at: friendship_accepted_at)

    xhr :post, :accept_friendship, {friendship_id: friendship.id}

    assert_response :success

    friendship.reload

    jsonResponse = JSON.parse(response.body)
    assert_equal 'error', jsonResponse['status']
    assert_equal 'friendshipAccepted', jsonResponse['errorType']
    assert_equal friendship_accepted_at.in_time_zone.to_s, friendship.accepted_at.to_s
  end

  test 'accept_friendship when exception raised during save' do
    other_user = User.create!(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    friendship = Friendship.create!(user: other_user, friend: @current_user, accepted_at: nil)

    Friendship.any_instance.stubs(:update_attributes).returns(false)

    xhr :post, :accept_friendship, {friendship_id: friendship.id}

    assert_response :success

    friendship.reload

    jsonResponse = JSON.parse(response.body)
    assert_equal 'error', jsonResponse['status']
    assert_equal 'cannotSave', jsonResponse['errorType']
  end

  test 'index get all user friends' do
    friend_1 = User.create!(username: 'user1', email: 'user1@ucsb.edu', password: 'password')
    friend_2 = User.create!(username: 'user2', email: 'user2@ucsb.edu', password: 'password')
    pending_friend = User.create!(username: 'user3', email: 'user3@ucsb.edu', password: 'password')
    not_friend = User.create!(username: 'user4', email: 'user4@ucsb.edu', password: 'password')

    friendship_1 = Friendship.create!(user: friend_1, friend: @current_user, accepted_at: DateTime.now)
    friendship_2 = Friendship.create!(user: @current_user, friend: friend_2, accepted_at: DateTime.now)
    Friendship.create!(user: pending_friend, friend: @current_user, accepted_at: nil)

    get :index

    assert_response :success
    assert_equal [friend_1, friend_2].sort, assigns(:friends).sort
  end
end
