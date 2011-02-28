require 'spec_helper'

describe User do

  subject { Factory(:user) }

  its(:participants) { should be_an_instance_of(Array) }
  its(:expense_categories) { should be_an_instance_of(Array) }
  its(:projects) { should be_an_instance_of(Array) }
  its(:receipts) { should be_an_instance_of(Array) }
  its(:expense_reports) { should be_an_instance_of(Array) }

  describe "#report" do
    let(:sara) { Factory(:sara) }
    let(:receipts) { [] }
    let!(:report) { sara.report(receipts, :as => "XYZ1234") }

    subject { report }

    context "with a report entered for some receipts" do
      let(:receipts) { [Factory(:chipotle_burrito, :user => sara, :expensable => true),
                         Factory(:starbucks_coffee, :user => sara, :expensable => true)] }

      its(:receipts) { should == receipts }
      its(:external_report_id) { should == "XYZ1234" }

      describe "the receipts" do
        subject { receipts }

        it { should all_have_expense_report report }
        it { should all_be_expensed }
      end
    end

    context "with several receipts the last of which raises on save" do
      let(:chipotle_burrito) { Factory(:chipotle_burrito, :user => sara, :expensable => true) }
      let(:starbucks_coffee) { Factory(:starbucks_coffee, :user => sara, :expensable => true) }

      let(:receipts) do
        unsavable_receipt = mock_model(Receipt).as_null_object
        unsavable_receipt.stub(:report) do |report|
          raise ActiveRecord::RecordInvalid.new report
        end
        [chipotle_burrito, starbucks_coffee, unsavable_receipt]
      end

      it { should be_new_record }
      its(:receipts) { should =~ [chipotle_burrito, starbucks_coffee] }
      its(:external_report_id) { should == "XYZ1234" }

      describe "the receipts when reloaded" do
        before :each do
          chipotle_burrito.reload
          starbucks_coffee.reload
        end

        subject { [chipotle_burrito, starbucks_coffee] }

        it { should_not all_have_expense_report report }
        it { should_not all_be_expensed }
      end

      describe "the reports receipts when reloaded" do
        before :each do
          report.receipts.reload
        end

        subject { report }

        its(:receipts) { should be_empty }
      end
    end
  end
end

RSpec::Matchers.define :all_be_expensed do
  match do |receipts_collection|
    receipts_collection.all? { |receipt| receipt.expensed? }
  end
end

RSpec::Matchers.define :all_have_expense_report do |report|
  match do |receipts_collection|
    receipts_collection.all? { |receipt| receipt.expense_report == report }
  end
end
