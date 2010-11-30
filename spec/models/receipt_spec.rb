require 'spec_helper'

describe Receipt do
  it "should have many participants" do
    receipt = Factory(:chipotle_burrito)
    receipt.participants.should be_an_instance_of(Array)
  end
  
  it "should support a note" do
    receipt = Factory(:chipotle_burrito)
    receipt.note.should be_nil
  end
end