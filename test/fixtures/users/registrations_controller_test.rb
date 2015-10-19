require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test 'the new action should work' do
    get :new
    assert_response :success
  end

  test 'creating a new user should work' do
    assert_difference 'User.count', 1 do
      post :create, user: {email: 'francois@malinowski.fr', username: 'YoBro', password: 'wassupBro', password_confirmation: 'wassupBro'}
    end

    assert_redirected_to root_path

    user = User.last
    assert_equal 'francois@malinowski.fr', user.email
    assert_equal 'YoBro', user.username
  end

  test 'creating a new user with an error in a field should remain on same page' do
    assert_no_difference 'User.count' do
      post :create, user: {email: 'francois@malinowski.fr', username: '', password: 'wassupBro', password_confirmation: 'wassupBro'}
    end

    assert_response :success
  end
end