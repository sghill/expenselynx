require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test "should save valid store" do
    store = Store.new(:name => 'anything unique')
    assert store.valid?
  end
  
  test "should not save store without name" do
    store = Store.new
    assert store.invalid?
  end
end
