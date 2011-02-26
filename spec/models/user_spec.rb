require 'spec_helper'

describe User do

  subject { Factory(:user) }

  its(:participants) { should be_an_instance_of(Array) }
  its(:expense_categories) { should be_an_instance_of(Array) }
  its(:projects) { should be_an_instance_of(Array) }
  its(:receipts) { should be_an_instance_of(Array) }
  its(:expense_reports) { should be_an_instance_of(Array) }
end
