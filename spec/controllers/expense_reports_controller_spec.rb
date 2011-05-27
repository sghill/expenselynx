require 'spec_helper'
require 'killer_rspec_rack'

describe ExpenseReportsController do
  include Devise::TestHelpers
  include KillerRspecRack::Matchers
  
  let!(:tom) { User.create(email: "tom@example.com", password: "security123") }
  let!(:sam) { User.create(email: "sam@example.com", password: "blahdeblah3") }
  let!(:sams_report) { ExpenseReport.create(external_report_id: "ZFS294093249032", user: sam) }
  let!(:burrito_palace) { Store.create(name: "Burrito Palace") }
  let!(:sams_burrito_receipt) { Receipt.create(total: 4.73, 
                                                store: burrito_palace,
                                        purchase_date: today,
                                           expensable: true,
                                       expense_report: sams_report,
                                                 user: sam) }
  let(:today) { Time.current.to_date }

  let(:sara) { Factory(:sara) }
  let(:store) { Factory(:chipotle) }
  
  let(:report) { ExpenseReport.create(:user => sara) }

  describe :show do
  
    it "should require login" do
      get :show, id: sams_report.to_param
      response.should redirect_to new_user_session_path
    end
    
    it "should have right expense report" do
      sign_in sam
      get :show, id: sams_report.to_param
      should assign(:expense_report).with(sams_report)
    end
    
    #note: don't know how to assert record not found with decent_exposure, so using instance variable
    it "should not show another user's report" do
      sign_in tom
      lambda { get :show, id: sams_report.to_param }.should raise_error ActiveRecord::RecordNotFound
    end
  
    it "should have receipts in the report" do
      sign_in sam
      get :show, id: sams_report.id
      assigns(:expense_report).receipts.first.should == sams_burrito_receipt
    end
  
  end
  
  describe :create do
  
    it "should require login" do
      post :create, receipt_ids: nil
      response.should redirect_to new_user_session_path
    end
  
    it "should make a new report" do
      external_id = "crazy report identifier"
      sign_in tom
      
      post :create, receipt_ids: nil, external_report_id: external_id
      get :show, id: assigns(:report).to_param
      
      assigns(:expense_report).external_report_id.should == external_id
    end
    
    it "should mark member receipts as expensed" do
      receipt = Receipt.create(total: 1, 
                               store: burrito_palace, 
                       purchase_date: today,
                          expensable: true,
                                user: tom)
      sign_in tom
      post :create, receipt_ids: [receipt.id]
      after_post_receipt = Receipt.find receipt.id
      after_post_receipt.should be_expensed
    end
    
    it "should mark member receipts as belonging to this expense report" do
      receipt = Receipt.create(total: 1, 
                               store: burrito_palace, 
                       purchase_date: 1.day.ago,
                          expensable: true,
                                user: tom)
      sign_in tom
      post :create, receipt_ids: [receipt.id]
      after_post_receipt = Receipt.find receipt.id
      after_post_receipt.expense_report.should == assigns(:report)
    end
  
  end

  describe :download do
    let(:report) { mock(:report) }

    before :each do
      sara.stub_chain(:expense_reports, :find).and_return(report)
    end

    def do_download
      get :download, :id => '1', :format => :csv
    end

    context "sara is logged in" do
      before :each do
        controller.stub(:current_user).and_return(sara)
        sign_in sara
      end

      it { do_download; should expose(:report).with(report) }

      it "should be downloadable" do
        controller.should_receive(:downloadable)
        do_download
      end

      it "should expire in 30.days" do
        controller.should_receive(:expires_in).with(30.days)
        do_download
      end

      describe "the response headers" do
        subject { do_download; response.headers }

        it { should have_key('Content-Type').with_value('text/csv; charset=utf-8') }
        it { should have_key('Content-Disposition').with_value("attachment; filename=\"download.csv\"") }
      end
    end

    context "no-one is logged in" do
      it "should require login to download" do
        do_download

        response.status.should == 401
      end
    end
  end
end

RSpec::Matchers.define :expose do |name|
  chain(:with) {|with| @with = with }
  match do |controller|
    controller.respond_to?(name) and controller.send(name) == @with
  end

  description do
    "expose #{name.inspect} with #{@with.inspect}"
  end

  failure_message_for_should do
    "expected controller to expose #{name.inspect} with #{@with.inspect}, but didn't."
  end

  failure_message_for_should_not do
    "expected controller not to expose #{name.inspect} with #{@with.inspect}, but did."
  end
end
