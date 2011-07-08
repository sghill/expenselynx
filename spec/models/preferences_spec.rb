require 'spec_helper'

describe Preferences do
  it "should belong to a user" do
    pref = Preferences.new
    pref.user.should be_nil
  end
  
  it "should return false for a default project when default_project_id is blank" do
    pref = Preferences.new
    pref.default_project?.should be_false
  end
  
  it "should return true for a default project when default_project_id is saved" do
    pref = Preferences.new(:default_project_id => 1)
    pref.default_project?.should be_true
  end
end
