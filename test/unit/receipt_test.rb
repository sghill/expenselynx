require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  def setup
    Store.create(:name => 'My Test Store')
    @store = Store.find_by_name('My Test Store')
  end
  
  test "should save valid receipt" do
    receipt = Receipt.new(:total => 10.23, 
                          :purchase_date => DateTime.now, 
                          :store_id => @store.id)
    assert receipt.valid?
  end
  
  #
  # total tests
  #
  test "should not save receipt without total" do
    receipt = Receipt.new(:purchase_date => DateTime.now,
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  test "should not save receipt with negative total" do
    receipt = Receipt.new(:total => -0.10, 
                          :purchase_date => DateTime.now,
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  test "should not save receipt with funky string total" do
    receipt = Receipt.new(:total => 'lots', 
                          :purchase_date => DateTime.now,
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  #
  # purchase_date tests
  #
  test "should not save receipt without purchase date" do
    receipt = Receipt.new(:total => 10.20,
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  test "should not save future purchase date" do
    receipt = Receipt.new(:total => 10.18, 
                          :purchase_date => DateTime.now + 1.day,
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  test "should not save funky string purchase date" do
    receipt = Receipt.new(:total => 1.42, 
                          :purchase_date => 'yesteryear',
                          :store_id => @store.id)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  #
  # store tests
  #
  test "should not save receipt without an associated store" do
    receipt = Receipt.new(:total => 11.32, :purchase_date => DateTime.now)
    assert receipt.invalid?
    assert receipt.errors[:store_id].any?
  end
  
  test "should not save receipt without an existing store" do
    receipt = Receipt.new(:total => 3.24,
                          :purchase_date => DateTime.now,
                          :store_id => @store.id + 1000)
    assert receipt.invalid?
    assert receipt.errors[:store_id].any?
  end
end
