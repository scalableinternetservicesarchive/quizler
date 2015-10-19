require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test 'index page should work' do
    get :index
    assert_response :success
  end
end
