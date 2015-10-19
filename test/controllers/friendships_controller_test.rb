require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = sign_in_as_user
  end

  test 'search_user action should work' do
    get :search_user
    assert_response :success
  end

  test 'fetch_users when no username typed in' do
    user_1 = User.create(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'Heather', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'Hellofranck', email: 'user3@ucsb.edu', password: 'password')

    xhr :get, :fetch_users, {username: ''}

    assert_response :success
    assert_equal [user_1, user_2, user_3], assigns(:users)

    expected_response_body = '$(".js-fetched-users").html("    francois - user1@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"2\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Heather - user2@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"3\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Hellofranck - user3@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"4\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n");'
    assert_equal expected_response_body, response.body
  end

  test 'fetch_users when looking for usernames having same substring' do
    user_1 = User.create(username: 'francois', email: 'user1@ucsb.edu', password: 'password')
    user_2 = User.create(username: 'Heather', email: 'user2@ucsb.edu', password: 'password')
    user_3 = User.create(username: 'Hellofranck', email: 'user3@ucsb.edu', password: 'password')

    xhr :get, :fetch_users, {username: 'fran'}

    assert_response :success
    assert_equal [user_1, user_3], assigns(:users)

    expected_response_body = '$(".js-fetched-users").html("    francois - user1@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"2\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n    Hellofranck - user3@ucsb.edu\n    <button class=\"js-add-friend-btn\" data-id=\"4\" data-path=\"/friends/create\" name=\"button\" type=\"submit\">Add Friend<\/button>\n    <br>\n");'
    assert_equal expected_response_body, response.body
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
    other_user = User.create(username: 'francois', email: 'user1@ucsb.edu', password: 'password')

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
    other_user = User.create(username: 'francois', email: 'user1@ucsb.edu', password: 'password')

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
end
