require 'spec_helper'

describe ExpenseCategory do
  it "should have many stores" do
    category = ExpenseCategory.new
    category.stores.should be_instance_of(Array)
  end
  
  context "validation" do
    it "must have a name" do
      category = ExpenseCategory.new
      category.should_not be_valid
    end
  end
end
