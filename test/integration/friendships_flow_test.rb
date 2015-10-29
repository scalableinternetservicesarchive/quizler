require 'test_helper'

class FriendshipsFlowTest < ActionDispatch::IntegrationTest

  def login(options = {})
    user_hash = {
        email: 'francois@malinowski.fr',
        username: 'hellouser',
        password: 'mypassword',
        password_confirmation: 'mypassword'
    }
    user_hash.merge!(options)

    current_user = User.create!(user_hash)

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: 'francois@malinowski.fr'
    fill_in 'Password', with: 'mypassword'
    click_button 'Sign in'
    current_user
  end

  test 'accept a friendship' do
    current_user = login
    future_friend = User.create!(email: 'myfriend@whatever.com', username: 'Badass friend', password: 'yoloyoloyolo', password_confirmation: 'yoloyoloyolo')
    Friendship.create!(user:future_friend, friend: current_user)

    visit root_path
    page.find('.js-nav-friends-dropdown-btn').click
    page.find('.js-nav-friends-friend-requests-link').click

    assert page.has_content?('You have 1 friend request.')
    assert page.has_content?('Badass friend')
    assert_equal 'Confirm', page.find('.js-confirm-friendship').text
    page.find('.js-confirm-friendship').click

    # Doesn't work, need to fix it!!
    # assert page.find('.js-confirm-friendship').text.include?('Friend')
  end

end
