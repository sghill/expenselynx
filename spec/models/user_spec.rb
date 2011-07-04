require 'spec_helper'

describe User do

  subject { Factory(:user) }

  its(:participants) { should be_an_instance_of(Array) }
  its(:expense_categories) { should be_an_instance_of(Array) }
  its(:projects) { should be_an_instance_of(Array) }
  its(:receipts) { should be_an_instance_of(Array) }
  its(:expense_reports) { should be_an_instance_of(Array) }

end

RSpec::Matchers.define :all_be_expensed do
  match do |receipts_collection|
    receipts_collection.all? { |receipt| receipt.expensed? }
  end
end

RSpec::Matchers.define :all_have_expense_report do |report|
  match do |receipts_collection|
    receipts_collection.all? { |receipt| receipt.expense_report == report }
  end
end
