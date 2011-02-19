require 'spec_helper'

describe DashboardController do
  include Devise::TestHelpers
  include RSpecMacros
  include ControllerMacros

  let!(:sara) { Factory(:sara) }

  context "sara has 5 receipts" do
    let(:saras_receipts) { [mock_model(Receipt),
                            mock_model(Receipt),
                            mock_model(Receipt)] }

    let(:saras_expense_reports) { [mock_model(ExpenseReport),
                                   mock_model(ExpenseReport)] }

    before :each do
      sign_in sara
      sara.stub(:receipts).and_return(saras_receipts)
      sara.stub_chain(:expense_reports, :recent).and_return(saras_expense_reports)
      controller.stub(:current_user).and_return(sara)
      Timecop.freeze
    end

    describe_action :index do
      assign(:receipts) { should =~ saras_receipts }
      assign(:receipt) { should be_a Receipt }
      assign(:receipt, :purchase_date) { should == Time.now.to_date }
      assign(:reports) { should == saras_expense_reports }
    end
  end

  context "sara has 4 projects" do
    let(:saras_projects) { [mock_model(Project),
                            mock_model(Project),
                            mock_model(Project),
                            mock_model(Project)]}

    context "sara is signed in" do
      before :each do
        sign_in sara
        sara.stub(:projects).and_return(saras_projects)
        controller.stub(:current_user).and_return(sara)
      end

      describe_action :projects do
        assign(:projects) { should == saras_projects }
      end
    end

    context "no-one is signed in" do
      describe_action :projects do
        the(:response) { should redirect_to(new_user_session_path) }
      end
    end
  end
end
