require 'test_helper'

class ExpenseReportControllerTest < ActionController::TestCase
  setup do
    @sara = Factory(:sara)
    @store = Factory(:chipotle)
    @today = DateTime.now.to_date
  end
  
  test "should GET show" do
    get :show
    assert_response :success
  end
  
  # test "show should have a collection of expensable receipts" do
  #     report
  #     sign_in @sara
  #     Receipt.create(:total => 1, :store => @store, :purchase_date => @today, :expensable => true, :expense_report => report)
  #   end

end
