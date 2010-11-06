require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = Factory(:receipt)
    @user = Factory(:user)
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
    sign_in @user
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
    sign_in @user
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
    sign_in @user
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
    sign_in @user
    get :show, :id => @receipt.to_param
    assert_response :success
  end

  test "should not get edit if not logged in" do
    get :edit, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should get edit when logged in" do
    sign_in @user
    get :edit, :id => @receipt.to_param
    assert_response :success
  end
  
  test "should not update receipt if not signed in" do
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update receipt when signed in" do
    sign_in @user
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_redirected_to receipt_path(assigns(:receipt))
  end
  
  test "should not destroy receipt if not signed in" do
    delete :destroy, :id => @receipt.to_param
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should destroy receipt" do
    sign_in @user
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end

    assert_redirected_to receipts_path
  end
  
  test "should show 5 receipts on index" do
    sign_in @user
    Factory(:chipotle_burrito)
    Factory(:starbucks)
    Factory(:best_buy_tv)
    Factory(:oil_filter)
    Factory(:baja_tacos)
    
    get :index
    assert_equal 5, assigns(:receipts).count
  end
  
  test "should show the 5 most recently added receipts on index" do
    sign_in @user
    Factory(:chipotle_burrito)
    sleep(0.5)
    Factory(:starbucks)
    sleep(0.5)
    Factory(:best_buy_tv)
    sleep(0.5)
    Factory(:oil_filter)
    sleep(0.5)
    last = Factory(:baja_tacos)
    
    get :index
    assert_equal last, assigns(:receipts).first
    assert_equal @receipt, assigns(:receipts).last
  end
end
