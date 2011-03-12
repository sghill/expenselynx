require 'spec_helper'

describe Receipt do

  let(:user) { Factory :user }

  describe "store relationship" do
    it "should create a new store if one doesn't exist with a new receipt" do
      beginning = Store.count
      Receipt.create(:purchase_date => 1.day.ago, :user => user, :total => 4.32, :store_name => "Delta")
      ending = Store.count
      (ending - beginning).should == 1
    end
    
    it "should find a current store if it exists regardless of case" do
      Store.create(:name => "Ikea")
      Receipt.create(:purchase_date => 1.day.ago, :user => user, :total => 9.23, :store_name => "ikEa", :note => "interesting receipt")
      Receipt.find_by_note("interesting receipt").store.should == Store.find_by_name("ikea")
    end
  end
  
  describe :exportable do
    it "should mark itself as non-exportable if its store has no expense category" do
      receipt = Receipt.create(:purchase_date => 1.day.ago, :user => user, :total => 2.54, :store_name => "Store #{Time.current.to_date.to_s}")
      receipt.exportable?.should be_false
    end
  end
  
  it "should have many participants" do
    receipt = Factory(:chipotle_burrito)
    receipt.participants.should be_an_instance_of(Array)
  end

  it "should support a note" do
    receipt = Factory(:chipotle_burrito)
    receipt.note.should be_nil
  end

  context "with 2 unexpensed, 1 expensed and 3 unexpensable for same user" do
    subject { user.receipts }

    let!(:chipotle_burrito) { Factory :chipotle_burrito, :expensable => true,
                                      :expensed => false,
                                      :user => user,
                                      :total => 0.50 }

    let!(:baja_tacos) { Factory :baja_tacos, :expensable => true,
                                :expensed => false,
                                :user => user,
                                :total => 0.50 }

    let!(:starbucks_coffee) { Factory :starbucks_coffee, :expensable => true,
                                      :expensed => true,
                                      :user => user,
                                      :total => 0.50 }

    let!(:oil_filter) { Factory :oil_filter, :expensable => false,
                                :expensed => false,
                                :user => user,
                                :total => 0.50 }

    let!(:another_oil_filter) { Factory :oil_filter, :expensable => false,
                                        :expensed => false,
                                        :user => user,
                                        :total => 0.50,
                                        :store => oil_filter.store }

    let!(:yet_another_oil_filter) { Factory :oil_filter, :expensable => false,
                                            :expensed => false,
                                            :user => user,
                                            :total => 0.50,
                                            :store => oil_filter.store }

    its(:unexpensed) { should include chipotle_burrito, baja_tacos }
    its(:expensed) { should include starbucks_coffee }
    its(:unexpensable) { should include oil_filter, another_oil_filter, yet_another_oil_filter }

    its(:recent) { should == [yet_another_oil_filter, another_oil_filter, oil_filter, starbucks_coffee, baja_tacos] }
  end

  describe "validation messages" do
    let(:purchase_date) { Time.current.to_date }
    let(:store) { Store.create(:name => 'My Test Store') }
    let(:sara) { Factory(:sara) }
    let(:user) { sara }
    let(:total) { 10 }
    let(:expensable) { false }
    let(:expensed) { false }
    let(:expense_report) { nil }

    subject do
      receipt = Receipt.new(:total => total,
                            :purchase_date => purchase_date,
                            :store => store,
                            :user => user,
                            :expensable => expensable,
                            :expensed => expensed,
                            :expense_report => expense_report)
      receipt.valid?
      receipt
    end

    context "purchased today by 'sara' at 'My Test Store' to the value of 10.23" do
      let(:total) { 10.23 }

      it { should be_valid }
    end

    context "purchased today by 'sara' at 'My Test Store' omitting total" do
      let(:total) { nil }

      it { should be_invalid }
      it { should have_error_message("can't be blank").on(:total) }
      it { should have_error_message("is not a number").on(:total) }
    end

    context "purchased today by 'sara' at 'My Test Store' with negative total" do
      let(:total) { -0.10 }

      it { should be_invalid }
      it { should have_error_message("must be greater than or equal to 0.01").on(:total) }
    end

    context "purchased today by 'sara' at 'My Test Store' with 'lots' total" do
      let(:total) { 'lots' }

      it { should be_invalid }
      it { should have_error_message("is not a number").on(:total) }
    end
    
    describe :purchase_date do
      context "purchased (?) by 'sara' at 'My Test Store'" do
        let(:purchase_date) { nil }

        it { should be_invalid }
      end

      context "purchased 'yesteryear' by 'sara' at 'My Test Store'" do
        let(:purchase_date) { 'yesteryear' }

        it { should be_invalid }
        it { should have_error_message("can't be blank").on(:purchase_date) }
      end
    end

    context "purchased today by 'sara' at (?)" do
      let(:store) { nil }

      it { should be_invalid }
      it { should have_error_message("does not exist").on(:store_id) } #should change to validates_presence_of
    end

    context "purchased today by 'sara' at unknown" do
      subject do
        receipt = Receipt.new(:total => total,
                              :purchase_date => purchase_date,
                              :store_id => 10000,
                              :user => sara)
        receipt.valid?
        receipt
      end

      it { should be_invalid }
      it { should have_error_message("does not exist").on(:store_id) }
    end

    context "purchased today by 'sara' at 'My Test Store' and is expensable" do
      let(:expensable) { true }
      it { should be_expensable }

      context "and not expensed" do
        let(:expensed) { false }
        it { should_not be_expensed }
      end

      context "and expensed" do
        let(:expensed) { true }
        it { should be_expensed }
      end
    end

    context "purchased today by 'sara' at 'My Test Store' and is not expensable" do
      let(:expensable) { false }
      it { should_not be_expensable }

      context "and expensed" do
        let(:expensed) { true }
        it { should be_invalid }
        it { should have_error_message("receipt isn't possible unless receipt is marked expensable").on(:expensed) }
      end
    end

    context "purchased today by (?) at 'My Test Store'" do
      let(:user) { nil }

      it { should be_invalid }
      it { should have_error_message("can't be blank").on(:user) } #should change to validates_presence_of
    end

    context "purchased today by 'sara' at 'My Test Store' with no expense report" do
      let(:expense_report) { nil }

      its(:expense_report) { should_not be_present }
    end

    context "purchased today by 'sara' at 'My Test Store' with expense report on unexpensable receipt" do
      let(:expense_report) { ExpenseReport.new }
      let(:expensable) { false }

      it { should be_invalid }
      it { should have_error_message("receipt is not marked expensable").on(:expense_report_id) }
    end
  end

  describe "reporting" do
    let!(:chipotle_burrito) { Factory :chipotle_burrito, :expensable => true,
                                      :expensed => false,
                                      :user => user,
                                      :total => 0.50 }

    let!(:report) { ExpenseReport.new :external_report_id => "1234" }

    let!(:expensed_burrito) { chipotle_burrito.report report }

    subject { expensed_burrito }

    it { should be_expensed }

    describe "the expense report" do
      subject { report }

      its(:receipts) { should include expensed_burrito }
    end
  end

  describe "a receipts with total 0.50" do
    subject { Factory :receipt_with_no_total, :user => user, :total => 0.50 }

    its(:total_money) { should == Money.new(50, "USD") }
    its(:total_cents) { should == 50 }
    its(:total_currency) { should == "USD" }
  end

  describe "a receipts with total_money 0.50 USD" do
    subject { Factory :receipt_with_no_total, :user => user, :total_money => Money.new(50, "USD") }

    its(:total_money) { should == Money.new(50, "USD") }
    its(:total) { should == 0.50 }
    its(:total_cents) { should == 50 }
    its(:total_currency) { should == "USD" }
  end

  describe "a receipts with total_money 0.50 AUD" do
    subject { Factory :receipt_with_no_total, :user => user, :total_money => Money.new(50, "AUD") }

    its(:total_money) { should == Money.new(50, "AUD") }
    its(:total) { should == 0.50 }
    its(:total_cents) { should == 50 }
    its(:total_currency) { should == "AUD" }
  end
end
