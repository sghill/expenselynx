require 'test_helper'

class ExpenseReportTest < ActiveSupport::TestCase
  test "should allow external report id" do
    report = ExpenseReport.new(:external_report_id => "7F3X2")
    
    assert report.valid?
  end
  
  test "should allow nothing for the external report id" do
    report = ExpenseReport.new(:external_report_id => nil)
    
    assert report.valid?
  end
end
