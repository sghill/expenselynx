require 'spec_helper'

describe ReceiptsController do
  include Devise::TestHelpers

  let!(:chipotle) { Factory(:chipotle) }
  let!(:john) { Factory(:user) }
  let!(:sara) { Factory(:sara) }
  let!(:receipt) { Receipt.create(:store => chipotle, :user => john, :purchase_date => 2.days.ago(Time.current), :total => 13.34) }
  let!(:today) { Time.current.to_date }

  it "should not get index if not logged in" do
    get :index
    response.should redirect_to new_user_session_path
  end

  it "should get index when logged in" do
    sign_in john
    get :index
    response.should be_success
    should_not assign(:receipts).with(nil)
  end

  it "form in index should have todays date preloaded" do
    sign_in john
    get :index
    assigns(:receipt).purchase_date.should == today
  end

  it "should not get new if not logged in" do
    get :new
    response.should redirect_to new_user_session_path
  end

  it "should get new when logged in" do
    sign_in john
    get :new
    response.should be_success
    should_not assign(:receipt).with(nil)
  end

  it "GET new should already have todays date for purchase date" do
    sign_in john
    get :new
    assigns(:receipt).purchase_date == Time.now.to_date
  end

  it "should not POST create if not logged in" do
    post :create, :receipt => { :store_name => "Target", :purchase_date => today, :total => 17.54 }
    response.should redirect_to new_user_session_path
  end

  it "should POST create receipt with date when logged in" do
    sign_in john

    post :create, :receipt => { :store_name => "Target", :purchase_date => today, :total => 18.46 }

    response.should redirect_to receipt_path(assigns(:receipt))
  end

  it "should not get show receipt if not logged in" do
    get :show, :id => receipt.to_param
    response.should redirect_to new_user_session_path
  end

  it "should get show receipt when logged in" do
    sign_in john
    post :create, :receipt => { :store_name => "Target",
                                :purchase_date => today,
                                :total => 19.43 }
    get :show, :id => assigns(:receipt).id
    response.should be_success
  end

  it "should not get edit if not logged in" do
    get :edit, :id => receipt.to_param
    response.should redirect_to new_user_session_path
  end

  it "should get edit when logged in" do
    sign_in john
    get :edit, :id => receipt.to_param
    response.should be_success
  end

  it "should not update receipt if not signed in" do
    put :update, :id => receipt.to_param, :receipt => receipt.attributes
    response.should redirect_to new_user_session_path
  end

  it "should update receipt when signed in" do
    sign_in john
    put :update, :id => receipt.to_param, :receipt => {:store_name => receipt.store.name,
                                                        :purchase_date => 1.day.ago,
                                                        :total => 8.32}
    response.should redirect_to receipt_path(assigns(:receipt))
  end

  it "should not destroy receipt if not signed in" do
    delete :destroy, :id => receipt.to_param
    response.should redirect_to new_user_session_path
  end

  it "should destroy receipt" do
    sign_in john
    old_count = Receipt.count
    delete :destroy, :id => receipt.to_param
    Receipt.count.should == old_count - 1
    response.should redirect_to receipts_path
  end

  #
  #
  #
  it "should show all receipts on index" do
    sign_in john
    post :create, :receipt => {:store_name => "Target",:purchase_date => today,:total => 14}
    post :create, :receipt => {:store_name => "Baja Fresh",:purchase_date => 1.day.ago,:total => 15}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => 2.days.ago,:total => 11.05}
    post :create, :receipt => {:store_name => "Target",:purchase_date => 3.days.ago,:total => 13.50}
    post :create, :receipt => {:store_name => "Target",:purchase_date => 4.days.ago,:total => 14.00}
    post :create, :receipt => {:store_name => "Chipotle",:purchase_date => 2.days.ago,:total => 17.00}

    get :index
    #because there is data in the setup...yikes
    assigns(:receipts).count.should == 7
  end

  it "should show the 5 most recently purchased receipts on index" do
    sign_in john
    oldest = Receipt.create(:store => chipotle,:purchase_date => 61.days.ago,:total => 14, :user => john)
             Receipt.create(:store => chipotle,:purchase_date => 50.days.ago,:total => 13, :user => john)
    newest = Receipt.create(:store => chipotle,:purchase_date => 2.days.ago, :total => 120,:user => john)
             Receipt.create(:store => chipotle,:purchase_date => 3.days.ago, :total => 10, :user => john)
             Receipt.create(:store => chipotle,:purchase_date => 19.days.ago,:total => 14, :user => john)

    get :index
    assigns(:receipts).first.should == newest
    assigns(:receipts).last.should == oldest
  end

  #
  # authorization
  #
  it "should not show a receipt created by another user" do
    sign_in sara
    post :create, :receipt => { :store_name => "Target", :purchase_date => today, :total => 17.34 }
    sign_out sara
    sign_in john

    lambda { get :show, :id => assigns(:receipt).id }.should raise_error ActiveRecord::RecordNotFound
  end

  it "should not show receipts created by other users" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => today, :total => 6.50 }
    sign_out john
    sign_in sara

    get :index
    assigns(:receipts).should be_empty
  end

  it "should not load a receipt for editing that belongs to another user" do
    johns_receipt = Receipt.create(:store => chipotle,:purchase_date => today,:total => 14,:user => john)

    sign_in sara

    lambda { get :edit, :id => johns_receipt.id }.should raise_error ActiveRecord::RecordNotFound
  end

  it "should not put an update for receipt belonging to another user" do
    johns_receipt = Receipt.create(:store => chipotle,:purchase_date => today,:total => 14,:user => john)

    sign_in sara

    johns_receipt[:purchase_date] = 1.day.ago

    lambda { put :update, :id => johns_receipt.id, :receipt => johns_receipt }.should raise_error ActiveRecord::RecordNotFound
  end

  it "should not be able to destroy another users receipt" do
    johns_receipt = Receipt.create(:store => chipotle,:purchase_date => today,:total => 14,:user => john)

    sign_in sara

    lambda { delete :destroy, :id => johns_receipt.id }.should raise_error ActiveRecord::RecordNotFound
  end

  #
  # participants
  #
  it "should add a participant name to a receipt" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 },
                  :participant_names => "craig lewis"
    assigns(:receipt).participants.first.should be_present
  end

  it "should add a comma separated list of participants to a receipt" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 },
                  :participant_names => "craig lewis, john henry"
    assigns(:receipt).should have(2).participants
  end

  it "should add the same participant to different receipts with different casing if spelling is the same" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 },
                  :participant_names => "craig lewis, john henry"
    post :create, :receipt => { :store_name => "Starbucks", :purchase_date => 3.days.ago, :total => 218.46 },
                  :participant_names => "CRAIG LEWIS"
    Participant.find_by_name("craig lewis").should have(2).receipts
  end

  it "should add the same participant to different receipts with multiple spaces if spelling is the same" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46 },
                  :participant_names => "craig lewis, john henry"
    post :create, :receipt => { :store_name => "Starbucks", :purchase_date => 3.days.ago, :total => 218.46 },
                  :participant_names => " CRAIG LEWIS"
    post :create, :receipt => { :store_name => "Mervyn's", :purchase_date => 3.days.ago, :total => 118.46 },
                  :participant_names => "CRAIG    LewIS"
    Participant.find_by_name("craig lewis").should have(3).receipts
  end

  it "should update receipt to include participant name" do
    sign_in john
    put :update, :id => receipt.to_param, :receipt => {:store_name => receipt.store.name,
                                                        :purchase_date => 1.day.ago,
                                                        :total => 8.32},
                                           :participant_names => "wilfred bremly, zacarias"

    assigns(:receipt).should have(2).participants
  end

  #
  # note
  #
  it "should create receipt with note" do
    sign_in john
    post :create, :receipt => { :store_name => "Target", :purchase_date => 1.day.ago, :total => 18.46, :note => "breakfast" }
    assigns(:receipt).note.should be_present
  end

  it "should update receipt with note" do
    sign_in john
    put :update, :id => receipt.to_param, :receipt => {:store_name => receipt.store.name,
                                                        :purchase_date => 1.day.ago,
                                                        :total => 8.32, :note => "team lunch"}
    assigns(:receipt).note.should be_present
  end
end
