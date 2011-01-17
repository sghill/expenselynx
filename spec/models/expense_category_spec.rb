require 'spec_helper'

describe ExpenseCategory do
  it "should have many stores" do
    category = ExpenseCategory.new
    category.stores.should be_instance_of(Array)
  end

  it "should have a static list of tw categories" do
    ExpenseCategory::CATEGORIES.should be_instance_of(Array)
  end

  it "should have many users" do
    category = ExpenseCategory.new
    category.users.should be_an_instance_of(Array)
  end

  context "validation" do
    it "must have a name" do
      category = ExpenseCategory.new
      category.should_not be_valid
    end
  end

  context "a number of user_store_expense_categories" do
    subject { ExpenseCategory.for_user_and_store(interesting_usec.user.id, interesting_usec.store.id) }

    let!(:interesting_expense_category) do
      ec = Factory(:expense_category);
      ec.user_store_expense_categories.create(:store => Factory(:chipotle), :user => Factory(:sara))
      ec
    end

    let!(:another_expense_category) { Factory(:expense_category) }
    let!(:interesting_usec) { interesting_expense_category.user_store_expense_categories.first }

    it { should include interesting_expense_category }
    it { should_not include another_expense_category }
  end
end
