require 'spec_helper'

describe Project do
  it "should belong to a user" do
    project = Project.new(:user => Factory(:user))
    project.user.should be_an_instance_of(User)
  end
end
