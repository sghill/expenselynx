require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @sara = Factory(:sara)
    @john = Factory(:user)
    @chipotle = Factory(:chipotle)
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
    assert_equal 5, assigns(:receipts).count
  end
  
  test "index should have receipts ordered by most recently purchased" do
    sign_in @sara
    newest = Receipt.create(:store => @chipotle,:purchase_date => 1.day.ago,:total => 9.90,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago,:total => 10,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @sara)
    oldest = Receipt.create(:store => @chipotle,:purchase_date => 9.days.ago,:total => 19,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 1.week.ago,:total => 13,:user => @sara)
    
    get :index
    assert_equal newest, assigns(:receipts).first
    assert_equal oldest, assigns(:receipts).last
  end
  
  test "index should show total of all receipts" do
    Receipt.create(:store => @chipotle,:purchase_date => 1.day.ago,:total => 9.90,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago,:total => 10,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @john)
    
    sign_in @sara
    get :index
    assert assigns(:stats)[:total].is_a?(Float)
    assert_equal 30.90, assigns(:stats)[:total]
  end
  
  test "index should show total of all unexpensed receipts" do
    Receipt.create(:store => @chipotle,:purchase_date => 1.day.ago,:total => 9.90,:user => @sara, :expensable => true, :expensed => true)
    Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago,:total => 10,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @sara, :expensable => true)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @john)
    
    sign_in @sara
    get :index
    assert assigns(:stats)[:unexpensed_total].is_a?(Float)
    assert_equal 11, assigns(:stats)[:unexpensed_total]
  end
  
  test "index should show total of all expensed receipts" do
    Receipt.create(:store => @chipotle,:purchase_date => 1.day.ago,:total => 9.90,:user => @sara, :expensable => true, :expensed => true)
    Receipt.create(:store => @chipotle,:purchase_date => 3.days.ago,:total => 10,:user => @sara)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @sara, :expensable => true)
    Receipt.create(:store => @chipotle,:purchase_date => 2.days.ago,:total => 11,:user => @john)
    
    sign_in @sara
    get :index
    assert assigns(:stats)[:expensed_total].is_a?(Float)
    assert_equal 9.90, assigns(:stats)[:expensed_total]
  end
  
  test "form in index should have todays date preloaded" do
    sign_in @sara
    get :index
    assert_equal Time.now.to_date, assigns(:receipt).purchase_date
  end
end
