require 'spec_helper'

describe Project do
  before do
    @john = Factory(:user)
    @sara = Factory(:sara)
  end

  it "should belong to a user" do
    project = Project.new(:user => @john)
    project.user.should be_an_instance_of User
  end
  
  it "should have many expense reports" do
    project = Project.new(:user => @john)
    project.expense_reports.should be_an_instance_of Array
  end

  it "should require a name" do
    project = Project.new(:user => @john)
    project.should_not be_valid
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
