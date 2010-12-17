require 'spec_helper'

describe ExpenseCategory do
  it "should have many stores" do
    category = ExpenseCategory.new
    category.stores.should be_instance_of(Array)
  end
  
  it "should have a static list of tw categories" do
    ExpenseCategory::CATEGORIES.should be_instance_of(Array)
  end
  
  it "should have many UserStoreExpenseCategories" do
    category = ExpenseCategory.new
    category.expense_categories.should be_an_instance_of(Array)
  end
  
  context "validation" do
    it "must have a name" do
      category = ExpenseCategory.new
      category.should_not be_valid
    end
  end
end
