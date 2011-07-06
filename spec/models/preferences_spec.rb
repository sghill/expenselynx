require 'spec_helper'

describe Preferences do
  it "should belong to a user" do
    pref = Preferences.new
    pref.user.should be_nil
  end
end
