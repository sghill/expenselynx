require 'spec_helper'
require 'carrierwave/test/matchers'

describe ExpenseReportUploader do
  include CarrierWave::Test::Matchers
  
  HORRIBLE_STATIC_FILE_LOCATION = "/Users/ThoughtWorks/sgdev/expenselynx/spec"

  before do
    @uploader = ExpenseReportUploader.new
  end

  context "When saving to a directory" do
    it "should save to expense_reports folder" do
      @uploader.store_dir.should include("expense_reports/")
    end
  end
end