require 'test_helper'

class ExpenseReportControllerTest < ActionController::TestCase
  setup do
    @sara = Factory(:sara)
    @store = Factory(:chipotle)
    @today = DateTime.now.to_date
    @report = ExpenseReport.create(:user => @sara)
  end
  
  #
  # show
  #
  test "should GET show when logged in" do
    sign_in @sara
    get :show, :id => @report.to_param
    assert_response :success
  end
  
  test "should have only expensable receipts belonging to the report on GET show" do
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
    sign_in @sara
    get :show, :id => @report.to_param
    assert_equal 1, assigns(:report).receipts.count
  end
  
  test "must be logged in to GET show" do
    get :show, :id => @report.id
    
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should only show the current users expense report on GET show" do
    john = Factory(:user)
    report = ExpenseReport.create(:user => john)
    
    sign_in @sara
    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => report.to_param
    end
  end

  #
  # create
  #
  test "should be logged in to access POST create" do
    post :create, :receipt_ids => nil
    
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should POST create when logged in" do
    sign_in @sara
    post :create, :receipt_ids => nil
    get :show, :id => assigns(:report).id
    assert_response :success
  end
  
  test "POST create when logged in should mark included receipts expensed" do
      @receipt1 = Receipt.create(:total => 1, 
                                 :store => @store, 
                                 :purchase_date => @today, 
                                 :expensable => true, 
                                 :user => @sara)
      @receipt2 = Receipt.create(:total => 11, 
                                 :store => @store, 
                                 :purchase_date => @today, 
                                 :expensable => true,
                                 :user => @sara)
      sign_in @sara
      post :create, :receipt_ids => [@receipt1.id, @receipt2.id]
      after_post_receipt1 = Receipt.find(@receipt1.id)
      after_post_receipt2 = Receipt.find(@receipt2.id)
      assert after_post_receipt1.expensed?
      assert after_post_receipt2.expensed?
  end
  
  test "POST create when logged in should associate included receipts to new expense report" do
      @receipt1 = Receipt.create(:total => 1, 
                                 :store => @store, 
                                 :purchase_date => @today, 
                                 :expensable => true, 
                                 :user => @sara)
      @receipt2 = Receipt.create(:total => 11, 
                                 :store => @store, 
                                 :purchase_date => @today, 
                                 :expensable => true,
                                 :user => @sara)
      sign_in @sara
      post :create, :expense_report => {:user => @sara, :receipt_ids => [@receipt1.id, @receipt2.id] }
      after_post_receipt1 = Receipt.find(@receipt1.id)
      after_post_receipt2 = Receipt.find(@receipt2.id)
      assert_equal assigns(:report), after_post_receipt1.expense_report
      assert_equal assigns(:report), after_post_receipt2.expense_report
  end
end