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

  context "with user" do
    let(:sara) { Factory(:sara) }

    subject { ExpenseReport.new(:user => sara) }

    it { should be_valid}
  end

  context "with user and external report id" do
    let(:sara) { Factory(:sara) }

    subject { ExpenseReport.new(:external_report_id => "7F3X2", :user => sara) }

    it { should be_valid}
  end

  context "with user and omitted external report id" do
    let(:sara) { Factory(:sara) }

    subject { ExpenseReport.new(:external_report_id => nil, :user => sara) }

    it { should be_valid}
  end

  context "with no user" do
    subject { ExpenseReport.new }

    it { should be_invalid }
  end

  context "with one receipt" do
    let(:sara) { Factory(:sara) }
    let(:chipotle) { Factory(:chipotle) }

    subject do
      report = ExpenseReport.create(:user => sara)
      Receipt.create(:total => 3.68,
                     :purchase_date => 1.day.ago,
                     :store => chipotle,
                     :expensable => true,
                     :expense_report => report,
                     :user => sara)
      report
    end

    its(:receipt_count) { should == 1 }
  end

  context "with two receipts with totals 3.68 and 33.32" do
    let(:sara) { Factory(:sara) }
    let(:chipotle) { Factory(:chipotle) }

    subject do
      report = ExpenseReport.create(:user => sara)
      Receipt.create(:total_money => Money.new(368, "USD"),
                     :purchase_date => 1.day.ago,
                     :store => chipotle,
                     :expensable => true,
                     :expense_report => report,
                     :user => sara)
      Receipt.create(:total_money => Money.new(3332, "USD"),
                     :purchase_date => 1.day.ago,
                     :store => chipotle,
                     :expensable => true,
                     :expense_report => report,
                     :user => sara)
      report
    end

    its(:receipt_sum) { should == Money.new(3700, "USD") }
  end
end
