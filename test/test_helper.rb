ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  require 'mocha'
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers

  def sign_in_as_user
    user = User.create(username: 'user_001', email: 'user_001@whatever.com', password: 'password')
    sign_in user
    user
  end
end

module ActionDispatch
  class IntegrationTest
    include Capybara::DSL
  end
end
