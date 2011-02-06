require 'spec_helper'

describe DashboardController do
  include Devise::TestHelpers
  
  before do
    @sara = Factory(:sara)
  end
  
  it "should return the most recent 5 reports" do
    ExpenseReport.create(:user => @sara, :created_at => 7.days.ago, :external_report_id => "report 1")
    ExpenseReport.create(:user => @sara, :created_at => 9.days.ago, :external_report_id => "report 10")
    ExpenseReport.create(:user => @sara, :created_at => 3.days.ago, :external_report_id => "report 100")
    most_recent = ExpenseReport.create(:user => @sara, :created_at => 1.days.ago, :external_report_id => "report 1000")
    ExpenseReport.create(:user => @sara, :created_at => 3.days.ago, :external_report_id => "report 10000")
    last_recent = ExpenseReport.create(:user => @sara, :created_at => 8.days.ago, :external_report_id => "report 100000")
    
    sign_in @sara
    get :index
    assigns(:reports).first.should == most_recent
    assigns(:reports).last.should == last_recent
  end
  
  describe "GET 'projects'" do
    it "should require a login" do
      get :projects
      response.should redirect_to(new_user_session_path)
    end
    
    it "should return all of the projects a user has" do
      energy = Project.create(:user => @sara, :name => "Large Energy Company")
      
      sign_in @sara
      get :projects
      assigns(:projects).first.should == energy
    end
    
    it "should return only the projects belonging to that user" do
      energy = Project.create(:user => @sara, :name => "Large Energy Company")
      banking = Project.create(:user => Factory(:user), :name => "Large Financial Company")
      
      sign_in @sara
      get :projects
      assigns(:projects).size.should == 1
      assigns(:projects).first.should == energy
    end
  end
end