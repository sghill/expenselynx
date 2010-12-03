require 'spec_helper'

describe ReportService do
  before do
    category = ExpenseCategory.create(:name => "Hotel")
    store = Store.create(:name => 'Chipotle', :expense_category => category)
    sara = Factory(:sara)
    participants = [Participant.create(:name => "tim", :user => sara), Participant.create(:name => "alice", :user => sara)]
    @full_receipt = Receipt.create(:purchase_date => 1.day.ago,
                                   :total => 12.45,
                                   :user => sara,
                                   :store => store,
                                   :note => "breakfast",
                                   :participants => participants)
  end
  
  it "should generate an array when given a receipt id" do
    service = ReportService.new
    service.flatten_receipt(@full_receipt.id).should be_instance_of(Array)
  end
  
  it "should contain the expense category in 0th position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    expense_category = @full_receipt.store.expense_category.name
    
    flat_receipt[0].should == expense_category
  end
  
  it "should contain the purchase date in the 1st position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    purchase_date = @full_receipt.purchase_date.to_date
    
    flat_receipt[1].should == purchase_date
  end
  
  it "should contain the total in the 2nd position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    total = @full_receipt.total
    
    flat_receipt[2].should == total
  end
  
  it "should contain the currency in the 3rd position" do
    # HACK: Only supporting USD right now
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    
    flat_receipt[3].should == "USD"
  end
  
  it "should contain the description in the 4th position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    description = @full_receipt.note
    
    flat_receipt[4].should == description
  end
  
  it "should contain the store name in the 5th position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    store_name = @full_receipt.store_name
    
    flat_receipt[5].should == store_name
  end
  
  it "should contain the payment type in the 6th position" do
    # HACK: Only supporting personal credit card now
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    
    flat_receipt[6].should == "Personal Card"
  end
  
  it "should contain the participants in the 7th position" do
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    
    assert flat_receipt[7].include? "tim"
    assert flat_receipt[7].include? ";"
    assert flat_receipt[7].include? "alice"
  end
  
  it "should contain the personal expenditures in the 8th position" do
    # HACK: Only supporting non-personal expenditures now (it's an expense report!)
    service = ReportService.new
    flat_receipt = service.flatten_receipt(@full_receipt.id)
    
    pending "no in the last position of array"
  end
end