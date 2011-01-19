require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @sara = Factory(:sara)
    @john = Factory(:user)
    @chipotle = Factory(:chipotle)
    Receipt.delete(:all)
  end

  test "should GET index if signed in" do
    sign_in @sara
    get :index
    assert_response :success
  end

  test "should redirect to sign in page if not signed in on GET index" do
    get :index
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "index should have a new receipt object for its form" do
    sign_in @sara
    get :index
    assert assigns(:receipt).is_a?(Receipt)
  end

  test "index should have 5 receipts" do
    sign_in @sara
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 13,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 12,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 11,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 10,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 19,:user => @sara)

    get :index
    assert assigns(:receipts).is_a?(Array)
    assert_equal @sara.receipts, assigns(:receipts)
  end

  #
  # index / expense reports
  #
  test "index should show 5 most recent expense reports" do
    ExpenseReport.create(:user => @sara, :external_report_id => "report 1")
    ExpenseReport.create(:user => @sara, :external_report_id => "report 10")
    ExpenseReport.create(:user => @sara, :external_report_id => "report 100")
    ExpenseReport.create(:user => @sara, :external_report_id => "report 1000")
    ExpenseReport.create(:user => @sara, :external_report_id => "report 10000")
    ExpenseReport.create(:user => @sara, :external_report_id => "report 100000")

    sign_in @sara
    get :index
    assert assigns(:reports).is_a?(Array)
    assert_equal 5, assigns(:reports).count
  end

  test "index should show only current users expense reports" do
    ExpenseReport.create(:user => @sara, :external_report_id => "report 1")
    ExpenseReport.create(:user => @john, :external_report_id => "report 10")

    sign_in @sara
    get :index
    assert_equal 1, assigns(:reports).count
  end

  test "form in index should have todays date preloaded" do
    sign_in @sara
    get :index
    assert_equal Time.now.to_date, assigns(:receipt).purchase_date
  end

  test "GET unexpensed should show all of the receipts waiting to be expensed" do
    Receipt.create(:store => @chipotle,:purchase_date => 1.day.ago,:total => 9.90,:user => @sara, :expensable => true, :expensed => true)
    Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago,:total => 10,:user => @sara)
    only_expensable = Receipt.create!(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @sara, :expensable => true)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @john)

    sign_in @sara
    get :unexpensed
    assert_equal 1, assigns(:receipts).count
    assert_equal only_expensable, assigns(:receipts).first
  end
end
