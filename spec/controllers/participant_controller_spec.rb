require 'spec_helper'

describe ParticipantsController do
  include Devise::TestHelpers

  before do
    @sara = Factory(:sara)
    @john = Factory(:user)
  end

  describe :edit do
    before do
      @participant = Participant.create!(:name => "Toby", :user => @sara)
    end
    
    context :authentication do
      it "should redirect if not authenticated" do
        get :edit, :id => @participant.to_param
        response.should redirect_to(new_user_session_path)
      end
    
      it "should be successful if authenticated" do
        sign_in @sara
        get :edit, :id => @participant.to_param
        response.should be_success
      end
      
      it "should not allow seeing other user's participants" do
        sign_in @john
        lambda { get :edit, :id => @participant.to_param }.should raise_error
      end
    end
    
    it "should contain requested participant" do
      sign_in @sara
      get :edit, :id => @participant.to_param
      assigns(:participant).name.should == "Toby"
    end
  end

  describe :update do
    before do
      @participant = Participant.create!(:name => "Toby #{Time.current}", :user => @sara)
      @updated_participant = { :name => "Pluto" }
    end
    
    it "should change receipt if logged in" do
      sign_in @sara
      post :update, :id => @participant.to_param, :participant => @updated_participant
      assigns(:participant).name.should == "Pluto"
    end

    it "should not change receipt if not logged in" do
      post :update, :id => @participant.to_param, :participant => @updated_participant
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe :show do
    before do
      @participant = Participant.create!(:name => "Toby", :user => @sara)
    end
    
    context :authentication do
      it "should disallow showing of other user's participants" do
        sign_in @john
        lambda { get :show, :id => @participant.to_param }.should raise_error
      end

      it "should redirect to sign in page if not logged in" do
        get :show, :id => @participant.to_param
        response.should redirect_to(new_user_session_path)
      end
    end
    
    it "should display basic information about the participant if logged in" do
      sign_in @sara
      get :show, :id => @participant.to_param
      assigns(:participant).name.should == "Toby"
      assigns(:participant).display?.should == true
    end
  end

  describe "GET 'search'" do
    it "should be successful" do
      sign_in @sara
      get :search
      response.should be_success
    end
    
    it "should return all participants when no term is provided" do
      chuck = Participant.create(:name => "Charles Bark", :user => @sara)
      
      sign_in @sara
      get :search
      assigns(:participants).should_not be_nil
    end
    
    it "should only return participants if a user is logged in" do
      get :search
      response.should redirect_to(new_user_session_path)
    end
    
    it "should only return the current users participants" do
      chuck = Participant.create(:name => "Charles Bark", :user => @sara)
      alf = Participant.create(:name => "Alfred", :user => @sara)
      leon = Participant.create(:name => "Leon", :user => @john)
      
      sign_in @sara
      get :search
      assigns(:participants).count.should == 2
    end
    
    it "should return participants in alphabetical order by name" do
      chuck = Participant.create(:name => "Charles Bark", :user => @sara)
      alf = Participant.create(:name => "Alfred", :user => @sara)
      ivan = Participant.create(:name => "Ivan", :user => @sara)
      
      sign_in @sara
      get :search
      assigns(:participants).first.should == alf
      assigns(:participants).last.should == ivan
    end
    
    describe "with search term" do
      it "should return only names starting with the term" do
        chuck = Participant.create(:name => "Charles Bark", :user => @sara)
        alf = Participant.create(:name => "Alfred", :user => @sara)
        albert = Participant.create(:name => "Albert", :user => @sara)
      
        sign_in @sara
        get :search, :term => 'al'
        assigns(:participants).count.should == 2
      end
    end
  end

  describe "GET 'index'" do
    it "should require login" do
      get :index
      response.should redirect_to(new_user_session_path)
    end
    
    it "should contain a list of the current users participants" do
      alf = Participant.create(:name => "Alfred", :user => @sara)
      ivan = Participant.create(:name => "Ivan", :user => @sara)
      
      sign_in @sara
      get :index
      assigns(:participants).length.should == 2
      assigns(:participants).first.should == alf
    end
  end
  
  describe "GET 'merge_zone'" do
    it "should require login" do
      get :merge_zone
      response.should redirect_to(new_user_session_path)
    end
    
    it "should contain all of the current users participants" do
      Participant.create(:name => "thomas", :user => @john)
      Participant.create(:name => "jokland", :user => @john)
      Participant.create(:name => "harold", :user => @sara)
      sign_in @john
      get :merge_zone
      assigns(:participants).should == @john.participants
    end
  end
  
  describe "POST 'merge'" do
    it "should require login" do
      post :merge, :participant_ids => nil
      response.should redirect_to(new_user_session_path)
    end
    
    it "should take me back to my dashboard once finished" do
      mobie = Participant.create(:name => "mobie", :user => @sara)
      moby = Participant.create(:name => "moby", :user => @sara)
      Receipt.create(:store => Store.create(:name => "Binstince Emporium"),
                     :purchase_date => 5.days.ago,
                     :total => 17.32,
                     :participants => [mobie, moby],
                     :user => @sara)
      sign_in @sara
      post :merge, :participant_ids => [mobie.id, moby.id], :participant_name => "toodles"
      response.should redirect_to(dashboard_index_path)
    end
    
    it "should remove the participants submitted to merge" do
      mobie = Participant.create(:name => "mobie", :user => @sara)
      moby = Participant.create(:name => "moby", :user => @sara)
      Receipt.create(:store => Store.create(:name => "Binstince Emporium"),
                     :purchase_date => 5.days.ago,
                     :total => 17.32,
                     :participants => [mobie, moby],
                     :user => @sara)
      @sara.receipts.length.should == 1
      @sara.receipts.first.participants.length.should == 2
      @sara.participants.length == 2

      sign_in @sara
      
      post :merge, :participant_ids => [mobie.id, moby.id], :participant_name => "toodles"
      User.find_by_email(@sara.email).receipts.first.participants.length.should == 1
      User.find_by_email(@sara.email).participants.length == 1
    end
  end
end
