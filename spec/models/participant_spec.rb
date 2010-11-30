require 'spec_helper'

describe Participant do
  before do
    @sara = Factory(:sara)
  end
  
  it "should require a name" do
    participant = Participant.new(:user => @sara)
    participant.should_not be_valid
  end
  
  it "should have a name of type string" do
    participant = Participant.new(:name => "turtle", :user => @sara)
    participant.name.should be_a_kind_of(String)
  end
  
  it "should belong to many receipts" do
    participant = Participant.new(:name => "frank", :user => @sara)
    participant.receipts.should be_an_instance_of(Array)
  end
  
  it "must belong to a user" do
    participant = Participant.new(:name => "alf")
    participant.should_not be_valid
  end
  
  it "should not be saved with the same user and name" do
    Participant.create(:name => "frank", :user => @sara)
    participant2 = Participant.new(:name => "frank", :user => @sara)
    participant2.should_not be_valid
  end
  
  it "should not be saved with the same user and name case insensitive" do
    Participant.create(:name => "frank", :user => @sara)
    participant2 = Participant.new(:name => "fRaNk", :user => @sara)
    participant2.should_not be_valid
  end
  
  context "searching" do
    it "should find or create by regardless of case" do
      original_tom = Participant.create(:name => "tom", :user => @sara)
      participant2 = Participant.find_or_create_by_name("TOM")
      participant2.should == original_tom
    end
    
    it "should find things starting with the term when searching" do
      tom = Participant.create(:name => "tom", :user => @sara)
      mitch = Participant.create(:name => "mitchell", :user => @sara)
      results = Participant.search_by_name("t")
      results.count.should == 1
    end
    
    it "should find things starting with the term when searching in a different case" do
      tom = Participant.create(:name => "thomas", :user => @sara)
      mitch = Participant.create(:name => "mitchell", :user => @sara)
      results = Participant.search_by_name("TH")

      results.first.should == tom
    end
  end
end
