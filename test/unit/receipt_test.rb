require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  def setup
    @today = DateTime.now.to_date
    @store = Store.create(:name => 'My Test Store')
    @sara = Factory(:sara)
  end
  
  test "should save valid receipt" do
    receipt = Receipt.new(:total => 10.23, 
                          :purchase_date => @today, 
                          :store => @store,
                          :user => @sara)
    assert receipt.valid?
  end
  
  #
  # total tests
  #
  test "should not save receipt without total" do
    receipt = Receipt.new(:purchase_date => @today,
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  test "should not save receipt with negative total" do
    receipt = Receipt.new(:total => -0.10, 
                          :purchase_date => @today,
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  test "should not save receipt with funky string total" do
    receipt = Receipt.new(:total => 'lots', 
                          :purchase_date => @today,
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:total].any?
  end
  
  #
  # purchase_date tests
  #
  test "should not save receipt without purchase date" do
    receipt = Receipt.new(:total => 10.20,
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  test "should not save future purchase date" do
    receipt = Receipt.new(:total => 10.18, 
                          :purchase_date => DateTime.now + 1.day,
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  test "should not save funky string purchase date" do
    receipt = Receipt.new(:total => 1.42, 
                          :purchase_date => 'yesteryear',
                          :store => @store,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:purchase_date].any?
  end
  
  #
  # store tests
  #
  test "should not save receipt without an associated store" do
    receipt = Receipt.new(:total => 11.32, 
                          :purchase_date => @today,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:store_id].any?
  end
  
  test "should not save receipt without an existing store" do
    receipt = Receipt.new(:total => 3.24,
                          :purchase_date => @today,
                          :store_id => @store.id + 1000,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:store_id].any?
  end
  
  test "should give the store name easily" do
    receipt = Receipt.new(:total => 5.54,
                          :purchase_date => @today,
                          :store => @store,
                          :user => @sara)
    assert_equal(@store.name, receipt.store_name)
  end
  
  #
  # expense flags
  #
  test "should have flag that indicates if the receipt is expensable" do
    receipt = Receipt.new(:total => 5.54,
                          :purchase_date => @today,
                          :store => @store,
                          :expensable => true,
                          :user => @sara)
    assert receipt.expensable?
  end
  
  test "should return false for expensable when not set" do
    receipt = Receipt.new(:total => 5.54,
                          :purchase_date => @today,
                          :store => @store,
                          :user => @sara)
    assert !receipt.expensable?
  end
  
  test "should have flag indicating receipts expensed status" do
    receipt = Receipt.new(:total => 5.21, 
                          :purchase_date => @today, 
                          :store => @store, 
                          :expensable => true,
                          :user => @sara)
    
    assert !receipt.expensed?
  end
  
  test "should not allow nonexpensable receipt to be expensed" do
    receipt = Receipt.new(:total => 12.21, 
                          :purchase_date => @today, 
                          :store => @store, 
                          :expensable => false, 
                          :expensed => true,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:expensed].any?
  end
  
  #
  # user
  #
  test "should always belong to user" do
    receipt = Receipt.new(:total => 5.54,
                          :purchase_date => @today,
                          :store => @store,
                          :user => nil)
    assert receipt.invalid?
    assert receipt.errors[:user].any?
  end
  
  #
  # expense report
  #
  test "should have ability to belong to expense report" do
    receipt = Receipt.new(:total => 6.68,
                          :purchase_date => @today,
                          :store => @store,
                          :expensable => true, 
                          :expensed => false,
                          :user => @sara)
    assert_nil receipt.expense_report
  end
  
  test "should not be in an expense report if not expensable" do
    report = ExpenseReport.new
    receipt = Receipt.new(:total => 3.68,
                          :purchase_date => @today,
                          :store => @store,
                          :expensable => false, 
                          :expensed => false,
                          :expense_report => report,
                          :user => @sara)
    assert receipt.invalid?
    assert receipt.errors[:expense_report_id].any?
  end
end
