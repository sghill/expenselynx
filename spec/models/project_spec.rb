require 'spec_helper'

describe Project do
  before do
    @john = Factory(:user)
  end
  
  it "should belong to a user" do
    project = Project.new(:user => @john)
    project.user.should be_an_instance_of(User)
  end
  
  it "should require a name" do
    project = Project.new(:user => @john)
    project.should_not be_valid
  end
end
