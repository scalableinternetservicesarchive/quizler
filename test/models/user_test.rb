require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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
end
