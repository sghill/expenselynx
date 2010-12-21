require 'spec_helper'

describe ParticipantService do
  it "should require participants" do
    lambda { ParticipantService.new }.should raise_error
  end
  
  it "should return a collection of participants, given a comma separated string" do
    service = ParticipantService.new("tom,bill,jill")
    assert service.participants_list.include?("tom")
    assert service.participants_list.include?("bill")
    assert service.participants_list.include?("jill")
  end
  
  it "should remove trailing and leading whitespace" do
    service = ParticipantService.new("tom, bill  ,jill")
    assert service.participants_list.include?("bill")
  end
  
  it "should remove weird middle spaces in names" do
    service = ParticipantService.new("sri fairchild, thomas    hutchcrafts   III")
    assert service.participants_list.include?("sri fairchild")
    assert service.participants_list.include?("thomas hutchcrafts III")
  end
end

