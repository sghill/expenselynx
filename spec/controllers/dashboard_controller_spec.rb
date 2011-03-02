require 'spec_helper'

describe DashboardController do
  include Devise::TestHelpers
  include RSpecMacros
  include ControllerMacros

  context "no-one is signed in" do
    describe_actions :index, :unexpensed do
      the(:response) { should redirect_to(new_user_session_path) }
    end
  end

  context "sara is signed in" do
    let(:sara) { Factory(:sara) }

    before :each do
      sign_in sara
      controller.stub(:current_user).and_return(sara)
    end

    context "sara has 5 receipts" do
      let(:saras_receipts) { [mock_model(Receipt),
                              mock_model(Receipt),
                              mock_model(Receipt)] }

      let(:saras_expense_reports) { [mock_model(ExpenseReport),
                                     mock_model(ExpenseReport)] }

      before :each do
        sara.stub(:receipts).and_return(saras_receipts)
        sara.stub_chain(:expense_reports, :recent).and_return(saras_expense_reports)
        Timecop.freeze
      end

      describe_action :index do
        the_assigned(:receipts) { should =~ saras_receipts }
        the_assigned(:receipt) { should be_a Receipt }
        the_assigned(:receipt, :purchase_date) { should == Time.current.to_date }
        the_assigned(:reports) { should == saras_expense_reports }
      end
    end

    context "sara has 4 unexpensed receipts" do
      let(:saras_unexpensed_receipts) { [mock_model(Receipt),
                                         mock_model(Receipt),
                                         mock_model(Receipt),
                                         mock_model(Receipt)] }

      before :each do
        sara.stub_chain(:receipts, :unexpensed).and_return(saras_unexpensed_receipts)
      end

      describe_action :unexpensed do
        the_assigned(:receipts) { should == saras_unexpensed_receipts }
      end
    end
  end
end
