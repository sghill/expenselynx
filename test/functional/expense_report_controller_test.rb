require 'test_helper'

class ExpenseReportControllerTest < ActionController::TestCase
  setup do
    @sara = Factory(:sara)
    @store = Factory(:chipotle)
    @today = DateTime.now.to_date
    @report = ExpenseReport.create(:user => @sara)
  end
  
  test "should GET show" do
    get :show, :id => @report.to_param
    assert_response :success
  end
  
  test "show should have only expensable receipts belonging to the report" do
    Receipt.create(:total => 1, 
                   :store => @store, 
                   :purchase_date => @today, 
                   :expensable => true, 
                   :expense_report => @report,
                   :user => @sara)
    Receipt.create(:total => 11, 
                   :store => @store, 
                   :purchase_date => @today, 
                   :expensable => false,
                   :user => @sara)
    Receipt.create(:total => 111,
                   :store => @store, 
                   :purchase_date => @today, 
                   :expensable => true,
                   :user => @sara)
    
    get :show, :id => @report.to_param
    assert_equal 1, assigns(:report).receipts.count
  end

end