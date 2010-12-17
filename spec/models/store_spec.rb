require 'spec_helper'

describe Store do
  it "should have many expense categories" do
    store = Store.new(:name => 'Target')
    store.expense_categories.should be_an_instance_of(Array)
  end
  
  it "should have many user store expense categories" do
    store = Store.new(:name => 'Meijer')
    store.user_store_expense_categories.should be_an_instance_of(Array)
  end
end