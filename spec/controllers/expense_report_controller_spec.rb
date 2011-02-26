require 'spec_helper'

describe ExpenseReportController do
  include Devise::TestHelpers

  let(:sara) { Factory(:sara) }
  let(:store) { Factory(:chipotle) }
  let(:today) { DateTime.now.to_date }
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
end
