require 'spec_helper'

describe Project do
  before do
    @john = Factory(:user)
    @sara = Factory(:sara)
  end
  
  describe :relationships do
    it "should belong to a user" do
      project = Project.new(:user => @john, :name => 'thing')
      project.user.should be_an_instance_of User
    end
  
    it "should have many expense reports" do
      project = Project.new(:user => @john, :name => 'thing')
      project.expense_reports.should be_an_instance_of Array
    end
  end

  describe :validation do
    it "should require end date after start date" do
      project = Project.new(:user => @john, :name => 'thing', :start_date => 1.day.ago, :end_date => 2.days.ago)
      project.should_not be_valid
    end
    
    it "should not allow already ended project to be current" do
      project = Project.new(:user => @john, :name => 'thing', :end_date => 2.days.ago, :current => true)
      project.should_not be_valid
    end
    
    it "should allow project with end date in future to be current" do
      project = Project.new(:user => @john, :name => 'thing', :end_date => 2.days.from_now, :current => true)
      project.should be_valid
    end

    it "should require a name" do
      project = Project.new(:user => @john)
      project.should_not be_valid
    end
  end

  describe 'current scope' do
    it "should return only projects marked as current" do
      current_project = Project.create!(:user => @john, :current => true, :name => 'thing')
      old_project = Project.create!(:user => @john, :current => false, :name => 'thing')
      Project.current.length.should == 1
      Project.current.should == [current_project]
    end
  end

  context "sara and john have one project each" do
    before :each do
      @saras_project = Project.create(:user => @sara, :name => "Large Energy Company")
      @johns_project = Project.create(:user => @john, :name => "Large Financial Company")
    end

    describe "sara" do
      subject { @sara.projects }

      it { should =~ [@saras_project]}
      it { should_not include @johns_project}
    end

    describe "john" do
      subject { @john.projects }

      it { should =~ [@johns_project]}
      it { should_not include @saras_project}
    end
  end
end
