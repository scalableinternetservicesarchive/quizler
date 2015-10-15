require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'index page should work' do
    get :index
    assert_response :success
  end
end
