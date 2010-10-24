require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  setup do
    @store = Factory(:chipotle)
    @update = {
      :name => 'Panera Bread'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store" do
    assert_difference('Store.count') do
      post :create, :store => @update
    end

    assert_redirected_to store_path(assigns(:store))
  end

  test "should show store" do
    get :show, :id => @store.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @store.to_param
    assert_response :success
  end

  test "should update store" do
    put :update, :id => @store.to_param, :store => @update
    assert_redirected_to store_path(assigns(:store))
  end

  test "should destroy store" do
    assert_difference('Store.count', -1) do
      delete :destroy, :id => @store.to_param
    end

    assert_redirected_to stores_path
  end
end
