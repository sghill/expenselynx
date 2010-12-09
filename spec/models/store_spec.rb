require 'spec_helper'

describe Store do
  it "should have an expense category property" do
    store = Store.new(:name => 'Target')
    store.expense_category.should be_nil
  end
end