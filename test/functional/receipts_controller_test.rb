require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = Factory(:receipt)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receipt with US date" do
    assert_difference('Receipt.count') do
      post :create, :receipt =>
      { :store_name => "Target",
        :purchase_date => "10/26/2010",
        :total => @receipt.total }
    end

    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should show receipt" do
    get :show, :id => @receipt.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @receipt.to_param
    assert_response :success
  end

  test "should update receipt" do
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end

    assert_redirected_to receipts_path
  end
  
  test "should show 5 receipts on the home page" do
    Factory(:chipotle_burrito)
    Factory(:starbucks)
    Factory(:best_buy_tv)
    Factory(:oil_filter)
    Factory(:baja_tacos)
    
    get :index
    assert_equal 5, assigns(:receipts).count
  end
end
