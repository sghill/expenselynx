require 'test_helper'

class ExpenseReportTest < ActiveSupport::TestCase
  setup do 
    @sara = Factory(:sara)
    @chipotle = Factory(:chipotle)
  end
  test "should save valid report" do
    report = ExpenseReport.new(:user => @sara)
    
    assert report.valid?
  end
  
  test "should allow external report id" do
    report = ExpenseReport.new(:external_report_id => "7F3X2", :user => @sara)
    
    assert report.valid?
  end
  
  test "should allow nothing for the external report id" do
    report = ExpenseReport.new(:external_report_id => nil, :user => @sara)
    
    assert report.valid?
  end
  
  test "should have receipts" do
    report = ExpenseReport.new(:user => @sara)
    
    assert report.receipts.is_a?(Array)
  end
  
  test "should always belong to a user" do
    report = ExpenseReport.new
    
    assert report.invalid?
  end
  
  test "should know how many receipts it has" do
    report = ExpenseReport.create(:user => @sara)
    Receipt.create(:total => 3.68, 
                   :purchase_date => 1.day.ago,
                   :store => @chipotle,
                   :expensable => true, 
                   :expense_report => report,
                   :user => @sara)
    
    assert_equal 1, report.receipt_count
  end
  
  test "should know the total value of its receipts" do
    report = ExpenseReport.create(:user => @sara)
    Receipt.create(:total => 3.68, 
                   :purchase_date => 1.day.ago,
                   :store => @chipotle,
                   :expensable => true, 
                   :expense_report => report,
                   :user => @sara)
    Receipt.create(:total => 33.32, 
                   :purchase_date => 1.day.ago,
                   :store => @chipotle,
                   :expensable => true, 
                   :expense_report => report,
                   :user => @sara)
    assert_equal 37, report.receipt_sum
  end
end
