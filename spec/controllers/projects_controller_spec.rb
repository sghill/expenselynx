require 'spec_helper'

describe ProjectsController do
  include Devise::TestHelpers
  
  before do
    @sara = Factory(:sara)
  end
  
  describe "GET 'index'" do
    it "should redirect if not logged in" do
      get :index
      response.should redirect_to(new_user_session_path)
    end
    
    it "should require login" do
      sign_in @sara
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should redirect if not logged in" do
      get :show
      response.should redirect_to(new_user_session_path)
    end
    
    it "should require login" do
      sign_in @sara
      get :show
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should redirect if not logged in" do
      get :edit
      response.should redirect_to(new_user_session_path)
    end
    
    it "should require login" do
      sign_in @sara
      get :edit
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should redirect if not logged in" do
      get :new
      response.should redirect_to(new_user_session_path)
    end
    
    it "should require login" do
      sign_in @sara
      get :new
      response.should be_success
    end
  end
end