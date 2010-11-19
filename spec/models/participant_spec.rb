require 'spec_helper'

describe Participant do
  context "during creation" do
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
    
    it "should belong to a user" do
      @sara = Factory(:sara)
      @participant = Participant.new(:name => "alf", :user => @sara)
      @participant.user.should eql(@sara)
    end
  end
end
