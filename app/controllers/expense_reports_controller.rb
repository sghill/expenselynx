 class ExpenseReportsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html
  #TODO: handle the expense_report forms as resources, with form_for in the views

  #FIXME: decent_exposure is adding confusion atm
  expose(:report) do
    current_user.expense_reports.find(params[:id])
  end
  
  def index
    @expense_reports = current_user.expense_reports
    respond_with @expense_reports
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
    @expense_report = current_user.expense_reports.find params[:id]
    @expense_report.receipts = current_user.receipts.where(id: params[:receipt_ids])
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
