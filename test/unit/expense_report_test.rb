require 'test_helper'

class ExpenseReportTest < ActiveSupport::TestCase
  setup do 
    @sara = Factory(:sara)
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
    report = ExpenseReport.new
    
    assert report.receipts.is_a?(Array)
  end
  
  test "should always belong to a user" do
    report = ExpenseReport.new
    
    assert report.invalid?
  end
end
