require 'spec_helper'
require 'killer_rspec_rack'

describe ExpenseReportsController do
  include Devise::TestHelpers
  include KillerRspecRack::Matchers

  let(:sara) { Factory(:sara) }
  let(:store) { Factory(:chipotle) }
  let(:today) { Time.current.to_date }
  let(:report) { ExpenseReport.create(:user => sara) }

  it "should GET show when logged in" do
    sign_in sara
    get :show, :id => report.to_param
    response.should be_success
  end

  it "should have report on GET show" do
    Receipt.create(:total => 1,
                   :store => store,
                   :purchase_date => today,
                   :expensable => true,
                   :expense_report => report,
                   :user => sara)
    Receipt.create(:total => 11,
                   :store => store,
                   :purchase_date => today,
                   :expensable => false,
                   :user => sara)
    Receipt.create(:total => 111,
                   :store => store,
                   :purchase_date => today,
                   :expensable => true,
                   :user => sara)
    sign_in sara
    get :show, :id => report.to_param
    should assign(:report).with(report)
  end

  it "should have receipts available in GET show" do
    receipt = Receipt.create(:total => 1,
                              :store => store,
                              :purchase_date => today,
                              :expensable => true,
                              :expense_report => report,
                              :user => sara)
    Receipt.create(:total => 11,
                   :store => store,
                   :purchase_date => today,
                   :expensable => false,
                   :user => sara)
    Receipt.create(:total => 111,
                   :store => store,
                   :purchase_date => today,
                   :expensable => true,
                   :user => sara)
    sign_in sara
    get :show, :id => report.to_param
    assigns(:report).receipts.first.should == receipt
  end

  it "must be logged in to GET show" do
    get :show, :id => report.id

    response.should redirect_to new_user_session_path
  end

  it "should only show the current users expense report on GET show" do
    john = Factory(:user)
    report = ExpenseReport.create(:user => john)

    sign_in sara
    lambda { get :show, :id => report.to_param }.should raise_error ActiveRecord::RecordNotFound
  end

  it "should be logged in to access POST create" do
    post :create, :receipt_ids => nil

    response.should redirect_to new_user_session_path
  end

  it "should POST create when logged in" do
    sign_in sara
    post :create, :receipt_ids => nil
    get :show, :id => assigns(:report).id
    response.should be_success
  end

  it "should POST create with external expense report id when logged in" do
    external_id = "4R32L"
    sign_in sara
    post :create, :receipt_ids => nil, :external_report_id => external_id
    get :show, :id => assigns(:report).id
    assigns(:report).external_report_id.should == external_id
  end

  it "POST create when logged in should mark included receipts expensed" do
      receipt1 = Receipt.create(:total => 1,
                                 :store => store,
                                 :purchase_date => today,
                                 :expensable => true,
                                 :user => sara)
      receipt2 = Receipt.create(:total => 11,
                                 :store => store,
                                 :purchase_date => today,
                                 :expensable => true,
                                 :user => sara)
      sign_in sara
      post :create, :receipt_ids => [receipt1.id, receipt2.id]
      after_post_receipt1 = Receipt.find(receipt1.id)
      after_post_receipt2 = Receipt.find(receipt2.id)
      after_post_receipt1.should be_expensed
      after_post_receipt2.should be_expensed
  end

  it "POST create when logged in should associate included receipts to new expense report" do
      receipt1 = Receipt.create(:total => 1,
                                 :store => store,
                                 :purchase_date => today,
                                 :expensable => true,
                                 :user => sara)
      receipt2 = Receipt.create(:total => 11,
                                 :store => store,
                                 :purchase_date => today,
                                 :expensable => true,
                                 :user => sara)
      sign_in sara
      post :create, :receipt_ids => [receipt1.id, receipt2.id]
      after_post_receipt1 = Receipt.find(receipt1.id)
      after_post_receipt2 = Receipt.find(receipt2.id)
      assigns(:report).id.should == after_post_receipt1.expense_report.id
      assigns(:report).id.should == after_post_receipt2.expense_report.id
  end

  describe "GET #download" do
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
