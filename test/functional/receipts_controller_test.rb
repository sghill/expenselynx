require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @chipotle = Factory(:chipotle)
    @john = Factory(:user)
    @sara = Factory(:sara)
    @receipt = Receipt.create(:store => @chipotle, :user => @john, :purchase_date => Time.now, :total => 13.34)
  end

  #
  # authorization
  #
  test "should not get index if not logged in" do
    get :index
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get index when logged in" do
    sign_in @john
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should not get new if not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get new when logged in" do
    sign_in @john
    get :new
    assert_response :success
  end
  
  test "should not post create if not logged in" do
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => "10/26/2010",
                                :total => @receipt.total }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should post create receipt with US date when logged in" do
    sign_in @john
    assert_difference('Receipt.count') do
      post :create, :receipt =>
      { :store_name => "Target",
        :purchase_date => "10/26/2010",
        :total => @receipt.total }
    end

    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should not get show receipt if not logged in" do
    get :show, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get show receipt when logged in" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => "10/26/2010",
                                :total => @receipt.total }
    get :show, :id => assigns(:receipt).id
    assert_response :success
  end

  test "should not get edit if not logged in" do
    get :edit, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get edit when logged in" do
    sign_in @john
    get :edit, :id => @receipt.to_param
    assert_response :success
  end
  
  test "should not update receipt if not signed in" do
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update receipt when signed in" do
    sign_in @john
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_redirected_to receipt_path(assigns(:receipt))
  end
  
  test "should not destroy receipt if not signed in" do
    delete :destroy, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should destroy receipt" do
    sign_in @john
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end

    assert_redirected_to receipts_path
  end
  
  #
  #
  #
  test "should show 5 receipts on index" do
    sign_in @john
    post :create, :receipt => {:store_name => "Target",:purchase_date => "10/26/2010",:total => 14}
    post :create, :receipt => {:store_name => "Baja Fresh",:purchase_date => "10/29/2010",:total => 15}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => "10/30/2010",:total => 11.05}
    post :create, :receipt => {:store_name => "Target",:purchase_date => "10/31/2010",:total => 13.50}
    post :create, :receipt => {:store_name => "Target",:purchase_date => "11/2/2010",:total => 14.00}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => "11/3/2010",:total => 17.00}
    
    get :index
    assert_equal 5, assigns(:receipts).count
  end
  
  test "should show the 5 most recently added receipts on index" do
    sign_in @john
    first = Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @john)
    sleep(0.25)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 13,:user => @john)
    sleep(0.25)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 120,:user => @john)
    sleep(0.25)
    Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 10,:user => @john)
    sleep(0.25)
    last = Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @john)
    
    get :index
    assert_equal last, assigns(:receipts).first
    assert_equal first, assigns(:receipts).last
  end
  
  #
  # authorization
  #
  test "should not show a receipt created by another user" do
    sign_in @sara
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => "10/26/2010",
                                :total => @receipt.total }
    sign_out @sara
    sign_in @john
    
    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => assigns(:receipt).id
    end
  end
  
  test "should not show receipts created by other users" do
    sign_in @john
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => "10/26/2010",
                                :total => @receipt.total }
    sign_out @john
    sign_in @sara
    
    get :index
    assert assigns(:receipts).empty?
  end
  
  test "should not load a receipt for editing that belongs to another user" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @john)
    
    sign_in @sara
    
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, :id => johns_receipt.id
    end
  end
  
  test "should not put an update for receipt belonging to another user" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @john)
    
    sign_in @sara
    
    johns_receipt[:purchase_date] = 1.day.ago
    
    assert_raise ActiveRecord::RecordNotFound do
      put :update, :id => johns_receipt.id, :receipt => johns_receipt
    end
  end
  
  test "should not be able to destroy another users receipt" do
    johns_receipt = Receipt.create(:store => @chipotle,:purchase_date => Time.now,:total => 14,:user => @john)
    
    sign_in @sara
    
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, :id => johns_receipt.id
    end
  end
end
