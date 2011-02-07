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
    
    it "should contain only the users projects" do
      energy = Project.create(:user => @sara, :name => "Big Energy Company")
      finance = Project.create(:user => Factory(:user), :name => "Big Financial Company")
      
      sign_in @sara
      get :index
      assigns(:projects).size.should == 1
      assigns(:projects).first.should == energy
    end
  end

  describe "GET 'show'" do
    it "should redirect if not logged in" do
      get :show
      response.should redirect_to(new_user_session_path)
    end
    
    it "should show a receipt the user owns" do
      energy = Project.create(:user => @sara, :name => "Big Energy Company")
      
      sign_in @sara
      get :show, :id => energy.id
      assigns(:project).should == energy
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