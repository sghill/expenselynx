require 'spec_helper'

describe ParticipantController do
  include Devise::TestHelpers

  describe "GET 'search'" do
    
    before do
      @sara = Factory(:sara)
      @chuck = Participant.create(:name => "Charles Bark", :user => @sara)
    end
    
    it "should be successful" do
      sign_in @sara
      get :search
      response.should be_success
    end
    
    it "should return all participants when no term is provided" do
      sign_in @sara
      get :search
      assigns(:participants).should_not be_nil
    end
    
    it "should only return participants if a user is logged in" do
      get :search
      response.should redirect_to(new_user_session_path)
    end
  end

end
