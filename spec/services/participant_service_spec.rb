require 'spec_helper'

describe ParticipantService do
  before do
    @john = Factory(:user)
    @service = ParticipantService.new(@john)
  end
  
  describe "merge" do
    before do
      @target = Store.create(:name => "target")
      @chipotle = Store.create(:name => "chipotle")
      @frank = Participant.create(:name => "frank", :user => @john)
      @franklin = Participant.create(:name => "franklin", :user => @john)
    end
    
    it "should remove the old participants from before the merge" do
      target_receipt = Receipt.create(:store => @target, 
                                      :purchase_date => 1.day.ago, 
                                      :total => 11.32, 
                                      :user => @john, 
                                      :participants => [@frank])
      chipotle_receipt = Receipt.create(:store => @chipotle, 
                                        :purchase_date => 1.day.ago, 
                                        :total => 65.32, :user => @john, 
                                        :participants => [@franklin])
      @john.participants.length.should == 2
      merged_participant = @service.merge([@frank.id, @franklin.id], "merged_participant")
      Participant.find_by_name(@frank.name).should be_nil
      Participant.find_by_name(@franklin.name).should be_nil
      User.find_by_email(@john.email).participants.length.should == 1
    end
    
    it "should assign the specified name to the superparticipant" do
      target_receipt = Receipt.create(:store => @target, 
                                      :purchase_date => 1.day.ago, 
                                      :total => 11.32, 
                                      :user => @john, 
                                      :participants => [@frank])
      chipotle_receipt = Receipt.create(:store => @chipotle, 
                                        :purchase_date => 1.day.ago, 
                                        :total => 65.32, :user => @john, 
                                        :participants => [@franklin])
      
      target_receipt.participants.should_not == chipotle_receipt.participants
      merged_participant = @service.merge([@frank.id, @franklin.id], "merged_participant")
      
      updated_target_receipt = Receipt.find(target_receipt.id)
      updated_chipotle_receipt = Receipt.find(chipotle_receipt.id)
      
      updated_target_receipt.participants.first.name.should == "merged_participant"
    end
    
    it "should append receipts of all participants to a new superparticipant" do
      target_receipt = Receipt.create(:store => @target, 
                                      :purchase_date => 1.day.ago, 
                                      :total => 11.32, 
                                      :user => @john, 
                                      :participants => [@frank])
      chipotle_receipt = Receipt.create(:store => @chipotle, 
                                        :purchase_date => 1.day.ago, 
                                        :total => 65.32, :user => @john, 
                                        :participants => [@franklin])
      
      target_receipt.participants.should_not == chipotle_receipt.participants
      merged_participant = @service.merge([@frank.id, @franklin.id])
      
      updated_target_receipt = Receipt.find(target_receipt.id)
      updated_chipotle_receipt = Receipt.find(chipotle_receipt.id)
      
      updated_target_receipt.participants.first.should == merged_participant
      updated_chipotle_receipt.participants.first.should == merged_participant
    end
    
    it "should not lose other participants on a receipt not being merged" do
      curmudgeon = Participant.create(:name => "curmudge", :user => @john)
      target_receipt = Receipt.create(:store => @target, 
                                      :purchase_date => 1.day.ago, 
                                      :total => 11.32, 
                                      :user => @john, 
                                      :participants => [@frank, curmudgeon])
      chipotle_receipt = Receipt.create(:store => @chipotle, 
                                        :purchase_date => 1.day.ago, 
                                        :total => 65.32, 
                                        :user => @john, 
                                        :participants => [@franklin, curmudgeon])
      
      target_receipt.participants.should_not == chipotle_receipt.participants
      merged_participant = @service.merge([@frank.id, @franklin.id])
      
      updated_target_receipt = Receipt.find(target_receipt.id)
      updated_chipotle_receipt = Receipt.find(chipotle_receipt.id)
      
      updated_target_receipt.participants.length.should == 2
      assert updated_target_receipt.participants.include?(curmudgeon)
      assert updated_target_receipt.participants.include?(merged_participant)
    end
  end
  
  describe "participant list" do
    it "should return a collection of participants, given a comma separated string" do
      tom = Participant.new(:name => "tom")
      bill = Participant.new(:name => "bill")
      service = ParticipantService.new(@john)
    
      service.participants_list("#{tom.name},#{bill.name}").first.should be_an_instance_of(Participant)
      service.participants_list("#{tom.name},#{bill.name}").should be_include(bill)
    end
  
    it "should remove trailing and leading whitespace" do
      bill = Participant.new(:name => "bill")
      service = ParticipantService.new(@john)
    
      service.participants_list("tom, bill  ,jill").should be_include(bill)
    end
  
    it "should remove weird middle spaces in names" do
      sri = Participant.new(:name => "sri fairchild")
      thomas = Participant.new(:name => "thomas hutchcrafts III")
      service = ParticipantService.new(@john)
    
      service.participants_list("sri fairchild, thomas    hutchcrafts   III").should be_include(sri)
      service.participants_list("sri fairchild, thomas    hutchcrafts   III").should be_include(thomas)
    end
  
    it "should add the given user to the list of participants" do
      service = ParticipantService.new(@john)
      service.participants_list("test,ha,laugh").first.user.should == @john
    end
  
    it "shouldn't freak out with an empty list of participants" do
      service = ParticipantService.new(@john)
      service.participants_list("").should == []
    end
  
    it "shouldn't freak out with a nil list of participants" do
      service = ParticipantService.new(@john)
      service.participants_list(nil).should == []
    end
  
    it "should be able to take an array of strings and return a list of participants" do
      jill = Participant.new(:name => "jill")
      service = ParticipantService.new(@john)
      service.participants_list_from_collection(['jill','bob']).first.should == jill
    end
  end
end

