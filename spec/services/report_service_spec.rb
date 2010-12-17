require 'spec_helper'

describe ReportService do
  
  before do
    @service = ReportService.new
  end
  
  it "should return a string" do
    @service.generate_csv_report.should be_an_instance_of(String)
  end
end