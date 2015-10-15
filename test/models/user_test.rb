require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'a user should have an username and an email' do
    user = User.new(username: 'whatever', email: 'hello@ucsb.edu')
    assert user.valid?

    user = User.new(username: '', email: 'hello@ucsb.edu')
    assert !user.valid?

    user = User.new(username: 'whatever', email: '')
    assert !user.valid?
  end

  test 'the email should be formatted correctly' do
    user = User.new(username: 'whatever', email: 'hello@ucsb.edu')
    assert user.valid?

    user = User.new(username: 'whatever', email: 'helloucsb.edu')
    assert !user.valid?

    user = User.new(username: 'whatever', email: 'hello@ucsbedu')
    assert !user.valid?
  end
end
