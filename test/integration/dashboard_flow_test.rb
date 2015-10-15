require 'test_helper'

class DashboardFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'visit the root page should point to the dashboard controller index action' do
    # visit the root page
    # make sure that Welcome! appears on the page
    visit root_path
    assert page.has_content?('Welcome!')
  end
end
