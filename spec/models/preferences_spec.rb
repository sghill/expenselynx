require 'spec_helper'

describe Preferences do
  it "should belong to a user" do
    user = Factory(:user)
    user.preferences.should be_nil
  end
end
