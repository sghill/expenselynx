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
  
  test "should find store case insensitive" do
    store = Store.create(:name => "Typical Party Store")
    found_store = Store.find_by_name("typical party stoRE")
    
    assert_equal(store, found_store)
  end
  
  test "should find store case sensitive" do
    store = Store.create(:name => "MyThai")
    found_store = Store.find_by_name(:case_sensitive => true, :name => "MyThai")
    
    assert_equal(store, found_store)
  end
  
  test "should find all stores case insensitive" do
    store = Store.create(:name => "Rainforest CaFe")
    stores_count = Store.find_all_by_name("rainforest cafe").count
    
    assert_equal(1, stores_count)
  end
  
  test "should find all stores case sensitive" do
    store = Store.create(:name => "Sports Authority")
    stores_count = Store.find_all_by_name(:case_sensitive => true, 
                                          :name => "Sports Authority").count
    
    assert_equal(1, stores_count)
  end
  
  test "should not create store when one exists" do
    store = Store.create(:name => 'Red Lobster')
   # store.save!
    Store.find_or_create_by_name('Red Lobster')
    stores_count = Store.find_all_by_name('Red Lobster').count
    
    assert_equal(1, stores_count)
  end
  
  test "should not create store when one exists case insensitive" do
    store = Store.create(:name => 'Banana rePuBlic')
    Store.find_or_create_by_name(:name => 'Banana Republic', :case_sensitive => false)
    stores_count = Store.find_all_by_name("Banana Republic").count
    
    assert_equal(1, stores_count)
   end
end
