 class ExpenseReportsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html

  expose(:report) do
    current_user.expense_reports.find(params[:id])
  end

  def show
    @expense_report = current_user.expense_reports.find params[:id]
    respond_with @expense_report
  end
  
  def edit
    @expense_report = current_user.expense_reports.find params[:id]
    respond_with @expense_report
  end
  
  def update
    receipts = current_user.receipts.where(id: params[:receipt_ids])
    @expense_report = current_user.expense_reports.find params[:id]
    @expense_report.receipts.each { |r| r.update_attribute(:expense_report, nil) }
    receipts.each { |r| r.update_attributes(expense_report: @expense_report) }
    @expense_report.update_attributes(params[:expense_report].merge(user: current_user))
    respond_with @expense_report
  end

  def create
    receipts = current_user.receipts.where(:id => params[:receipt_ids])

    @report = current_user.report receipts, :as => params[:external_report_id]

    unless @report.new_record?
      redirect_to @report
    end
  end

  def download
    downloadable and expires_in 30.days
    respond_to do |format|
      format.csv
    end
  end
end
