require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end
  
  it "should have participants" do
    @user.participants.should be_an_instance_of(Array)
  end
  
  it "should have many expense categories" do
    @user.expense_categories.should be_an_instance_of(Array)
  end
  
  it "should have many projects" do
    @user.projects.should be_an_instance_of(Array)
  end
end