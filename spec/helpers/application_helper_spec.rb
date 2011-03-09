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
  
  describe :grid_for do
    before do
      @receipts = [Receipt.make(:colins_tv_from_circuit_city)]
    end
    
    context :default do
      subject { grid_for(@receipts) }
    
      it { should include "Purchase Date" }
      it { should include "Store" }
      it { should include "Total" }
    end
  end
end
