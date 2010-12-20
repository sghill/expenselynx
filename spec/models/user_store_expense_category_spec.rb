require 'spec_helper'

describe UserStoreExpenseCategory do
  before do
    @cat = UserStoreExpenseCategory.new
  end
  
  it "should belong to an expense category" do
    @cat.expense_category.should be_nil
  end
  
  it "should require a user" do
    @cat.should_not be_valid
  end
  
  it "should belong to a store" do
    @cat.store.should be_nil
  end
end
