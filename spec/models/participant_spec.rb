require 'spec_helper'

describe Participant do
  context "When creating a participant" do
    it "should require a name" do
      @participant = Participant.new
      @participant.should_not be_valid
    end
    
    it "should have a name of type string" do
      @participant = Participant.new(:name => "turtle")
      @participant.name.should be_a_kind_of(String)
    end
    
    it "should belong to many receipts" do
      @participant = Participant.new(:name => "frank")
      @participant.receipts.should be_an_instance_of(Array)
    end
  end
end
