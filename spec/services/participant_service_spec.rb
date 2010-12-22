require 'spec_helper'

describe ParticipantService do
  before do
    @john = Factory(:user)
  end
  
  it "should return a collection of participants, given a comma separated string" do
    tom = Participant.new(:name => "tom")
    bill = Participant.new(:name => "bill")
    service = ParticipantService.new("#{tom.name},#{bill.name}", @john)
    
    service.participants_list.first.should be_an_instance_of(Participant)
    service.participants_list.should be_include(bill)
  end
  
  it "should remove trailing and leading whitespace" do
    bill = Participant.new(:name => "bill")
    service = ParticipantService.new("tom, bill  ,jill", @john)
    
    service.participants_list.should be_include(bill)
  end
  
  it "should remove weird middle spaces in names" do
    sri = Participant.new(:name => "sri fairchild")
    thomas = Participant.new(:name => "thomas hutchcrafts III")
    service = ParticipantService.new("sri fairchild, thomas    hutchcrafts   III", @john)
    
    service.participants_list.should be_include(sri)
    service.participants_list.should be_include(thomas)
  end
  
  it "should add the given user to the list of participants" do
    service = ParticipantService.new("test,ha,laugh", @john)
    service.participants_list.first.user.should == @john
  end
  
  it "shouldn't freak out with an empty list of participants" do
    service = ParticipantService.new("", @john)
    service.participants_list.should == []
  end
  
  it "shouldn't freak out with a nil list of participants" do
    service = ParticipantService.new(nil, @john)
    service.participants_list.should == []
  end
end

