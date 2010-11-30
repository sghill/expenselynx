require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  setup do
    Factory(:chipotle)
    @baja_fresh = Factory(:baja_fresh)
    Factory(:target)
    @best_buy = Factory(:best_buy)
  end
  
  test "should return all stores when searching without term" do
    get :search
    assert_equal 4, assigns(:stores).count
  end
  
  test "should return only stores starting with the search term" do
    get :search, :term => 'b'
    stores = assigns(:stores)
    
    assert_equal 2, stores.count
    assert stores.include?(@best_buy)
    assert stores.include?(@baja_fresh)
  end
  
  test "should return stores starting with the search term in alphabetical order by name" do
    get :search, :term => 'b'
    stores = assigns(:stores)
    
    assert_equal @baja_fresh, stores.first
    assert_equal @best_buy, stores.last 
  end
end
