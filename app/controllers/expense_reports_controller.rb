class ExpenseReportsController < ApplicationController

  respond_to :html

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
  
  def new
    @expense_report = ExpenseReport.new
    respond_with @expense_report
  end
  
  def edit
    @expense_report = current_user.expense_reports.find params[:id]
    respond_with @expense_report
  end
  
  def update
    @expense_report = current_user.expense_reports.find params[:id]
    
    #clear receipts
    unless @expense_report.receipts.empty?
      @expense_report.receipts.each do |receipt|
        receipt.expense_report = nil
        receipt.save
      end
    end
    
    @expense_report.update_attributes(params[:expense_report].merge(:user => current_user))
    @expense_report.update_attributes(:receipts => [])
    #FIXME: just plain ugly...nesting receipts in reports threw warnings because of my attr_accessible
    unless params[:receipts].nil?
      params[:receipts].each do |receipt_id|
        r = Receipt.find(receipt_id.to_i)
        @expense_report.receipts << r
        r.expense_report = @expense_report
        r.save     
      end
    end

    @expense_report.reset_receipts_count_cache
    @expense_report.save
    respond_with @expense_report
  end

  def create
    if params[:expense_report].nil? || params[:expense_report].empty?
      @expense_report = ExpenseReport.new(:user => current_user)
    else
      @expense_report = ExpenseReport.new(params[:expense_report].merge(:user => current_user))
    end
    
    #FIXME: just plain ugly...nesting receipts in reports threw warnings because of my attr_accessible
    unless params[:receipts].nil?
      params[:receipts].each do |receipt_id|
        r = Receipt.find(receipt_id.to_i)
        @expense_report.receipts << r
        r.expense_report = @expense_report
        r.save     
      end
    end
    
    @expense_report.reset_receipts_count_cache
    @expense_report.save
    respond_with @expense_report
  end

  def download
    downloadable and expires_in 30.days
    respond_to do |format|
      format.csv
    end
  end
end
