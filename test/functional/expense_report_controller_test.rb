require 'test_helper'

class ExpenseReportControllerTest < ActionController::TestCase
  test "should GET show" do
    get :show
    assert_response :success
  end

end
