require 'spec_helper'

describe ExpenseReport do
  let(:sara) { Factory(:sara) }

  context "with 6 expense reports" do
    subject { ExpenseReport }

    before :each do
      ExpenseReport.create(:user => sara, :created_at => 9.days.ago, :external_report_id => "report 10")
      @forth_most = ExpenseReport.create(:user => sara, :created_at => 7.days.ago, :external_report_id => "report 1")
      @third_most = ExpenseReport.create(:user => sara, :created_at => 3.days.ago, :external_report_id => "report 100")
      @most_recent = ExpenseReport.create(:user => sara, :created_at => 1.days.ago, :external_report_id => "report 1000")
      @second_most = ExpenseReport.create(:user => sara, :created_at => 3.days.ago, :external_report_id => "report 10000")
      @last_recent = ExpenseReport.create(:user => sara, :created_at => 8.days.ago, :external_report_id => "report 100000")
    end

    its(:recent) { should == [@most_recent,
                              @second_most,
                              @third_most,
                              @forth_most,
                              @last_recent]}
  end
end
