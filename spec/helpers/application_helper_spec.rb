#encoding: utf-8

require 'spec_helper'

describe ApplicationHelper do
  describe :boolean_to_check do
    context "when true param" do
      subject { boolean_to_check(true) }

      it { should == "✓" }
    end

    context "when false param" do
      subject { boolean_to_check(false) }

      it { should == "—" }
    end
  end
  
  describe :separate_links do
    subject { separate_links("home", "dashboard", "unexpensed") }
    
    it { should == "home :: dashboard :: unexpensed"}
  end

  describe "#money" do
    context "where argument is USD3.00" do
      subject { money Money.new(300, "USD") }

      it { should == "$3.00"}
    end
  end

  
  describe :grid_for do
    before do
      @receipts = [Factory.create(:colins_unexpensed_tv_from_circuit_city)]
    end
    
    context :default do
      subject { grid_for(@receipts) }
    
      it { should include "purchased on" }
      it { should include "from" }
      it { should include "for" }
      it { should include @receipts.first.purchase_date.to_s }
      it { should include @receipts.first.store.name }
      it { should include @receipts.first.total.to_s }
      it { should include link_to money(@receipts.first.total_money), [@receipts.first] }
      it { should include link_to @receipts.first.store_name, [:edit, @receipts.first.store] }
    end
    
    context :editable do
      subject { grid_for(@receipts, { :editable => true }) }
      
      it { should include "input" }
      it { should include "checkbox" }
      it { should include "receipt_ids[]" }
      it { should include "select_all" }
    end
    
    context :shows_expense_status do
      subject { grid_for(@receipts, { :shows_expense_status => true }) }
      
      it { should include "expensable?" }
      it { should include "expensed?" }
      it { should include "✓" }
      it { should include "—" }
    end
    
    context :shows_export_status do
      subject { grid_for(@receipts, { :shows_export_status => true }) }
      it { should include "export ready?" }
      it { should include "—" }
    end
  end
end
