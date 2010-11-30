require 'spec_helper'

describe User do
  it "should have participants" do
    @user = Factory(:user)
    @user.participants.should be_an_instance_of(Array)
  end
end