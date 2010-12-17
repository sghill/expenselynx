require 'spec_helper'

describe UserStoreExpenseCategory do
  before do
    @cat = UserStoreExpenseCategory.new
  end
  
  it "should belogn to expense category" do
    @cat.expense_category.should be_nil
  end
  
  it "should belong to a user" do
    @cat.user.should be_nil
  end
  
  it "should belong to a store" do
    @cat.store.should be_nil
  end
end
