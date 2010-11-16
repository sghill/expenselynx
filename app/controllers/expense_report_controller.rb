class ExpenseReportController < ApplicationController
  before_filter :authenticate_user!, :only => [:show, :create]
  
  def show
    @report = current_user.expense_reports.find(params[:id])
  end
  
  def create
    @report = ExpenseReport.new(params[:expense_report])
    if params[:expense_report][:receipt_ids]
      params[:expense_report][:receipt_ids].each do |receipt_id|
        receipt = current_user.receipts.find(receipt_id)
        receipt.expensed = true
        receipt.save!
      end
    end
    
    if @report.save
      redirect_to @report
    end
  end
end
