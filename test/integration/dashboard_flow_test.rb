require 'test_helper'

class DashboardFlowTest < ActionDispatch::IntegrationTest

  def login
    User.create({
      email: 'francois@malinowski.fr',
      username: 'hellouser',
      password: 'mypassword',
      password_confirmation: 'mypassword'
    })

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: 'francois@malinowski.fr'
    fill_in 'Password', with: 'mypassword'
    click_button 'Sign in'
  end

  test 'visit the root page should point to the dashboard controller index action' do
    visit root_path
    assert page.has_content?('Quizzle Time!')
  end

  test 'pressing sign up link should point to sign up page' do
    visit root_path
    click_link('Sign up')
    assert_equal new_user_registration_path, page.current_path
    assert page.has_content?('Sign up')
  end

  test 'log out link is not visible when we\'re not logged in' do
    visit root_path
    assert page.has_no_content?('Log out')
  end

  test 'Sign in link is visible on main page when we\'re not logged in and it goes to sign in page' do
    User.create({
      email: 'francois@malinowski.fr',
      username: 'hellouser',
      password: 'mypassword',
      password_confirmation: 'mypassword'
    })

    visit root_path

    click_link('Sign in')
    assert_equal new_user_session_path, page.current_path

    fill_in 'Email', with: 'francois@malinowski.fr'
    fill_in 'Password', with: 'mypassword'

    click_button 'Sign in'
    assert_equal root_path, page.current_path
    assert page.has_content?('Signed in successfully')
  end

  test 'log out link is visible when we\'re logged in. Logging out goes to main page' do
    login

    visit root_path
    assert page.has_content?('Log out')

    page.find('.js-dashboard-logout-link').click
    assert_equal root_path, page.current_path
    assert page.has_no_content?('Log out')
    assert page.has_content?('Sign in')
    assert page.has_content?('Sign up')
  end

end
