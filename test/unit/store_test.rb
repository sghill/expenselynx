require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test "should save valid store" do
    store = Store.new(:name => 'anything unique')
    assert store.valid?
  end
  
  test "should not save store without name" do
    store = Store.new
    assert store.invalid?
    assert store.errors[:name].any?
  end
  
  test "should not save store with same name" do
    store1 = Store.new(:name => 'Old Navy')
    store2 = Store.new(:name => 'Old Navy')
    store1.save!
    
    assert store2.invalid?
    assert store2.errors[:name].any?
  end
  
  test "should not save store with same name but different case" do
    store1 = Store.new(:name => 'La Shish')
    store2 = Store.new(:name => 'la shish')
    store1.save!
    
    assert store2.invalid?
    assert store2.errors[:name].any?
  end
end
