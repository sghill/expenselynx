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
      saras_project = Project.create(:user => @sara, :name => "Big Energy Company")
      johns_receipt = Project.create(:user => Factory(:user), :name => "Big Financial Company")

      sign_in @sara
      get :index
      assigns(:projects).size.should == 1
      assigns(:projects).first.should == saras_project
    end
  end

  describe "GET 'show'" do
    it "should redirect if not logged in" do
      get :show, :id => 1
      response.should redirect_to(new_user_session_path)
    end

    it "should show a project the user owns" do
      saras_project = Project.create(:user => @sara, :name => "Big Energy Company")

      sign_in @sara
      get :show, :id => saras_project.id
      assigns(:project).should == saras_project
    end

    it "should not show a project the user doesn't own" do
      not_saras_project = Project.create(:user => Factory(:user), :name => "Top Secret Popcorn")

      sign_in @sara
      lambda { get :show, :id => not_saras_project.id }.should raise_error
    end
  end

  describe "GET 'edit'" do
    it "should redirect if not logged in" do
      get :edit, :id => 1
      response.should redirect_to(new_user_session_path)
    end

    it "should load a project the user owns" do
      saras_project = Project.create(:user => @sara, :name => "Big Energy Company")

      sign_in @sara
      get :edit, :id => saras_project.id
      assigns(:project).should == saras_project
    end

    it "should not show a project the user doesn't own" do
      not_saras_project = Project.create(:user => Factory(:user), :name => "Top Secret Popcorn")

      sign_in @sara
      lambda { get :edit, :id => not_saras_project.id }.should raise_error
    end
  end

  describe "PUT 'update'" do
    it "should update a project when logged in" do
      project = Project.create(:user => @sara, :name => "Big Energy Company")

      sign_in @sara
      put :update, :id => project.id, :project => {:user => @sara, :name => "Large Energy Co"}
      response.should be_redirect
      assigns(:project).name.should == "Large Energy Co"
    end

    it "should not update a project belonging to another user" do
      project = Project.create(:user => Factory(:user), :name => "Big Energy Company")

      sign_in @sara
      lambda {
        put :update, :id => project.id, :project => {:user => @sara, :name => "Large Energy Co"}
      }.should raise_error
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

    it "should have an empty project ready to go" do
      sign_in @sara
      get :new
      assigns(:project).should be_an_instance_of(Project)
    end
  end

  describe "POST 'create'" do
    it "should create a project when logged in" do
      sign_in @sara
      post :create, :project => { :name => "good project" }
      response.should redirect_to(assigns(:project))
      @sara.projects.size.should == 1
    end
  end
end
