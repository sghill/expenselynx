require 'report_service'

class ExpenseReportController < ApplicationController
  before_filter :authenticate_user!, :only => [:show, :create]
  
  def show
    @report = current_user.expense_reports.find(params[:id])
  end
  
  def create
    @report = ExpenseReport.new(:external_report_id => params[:external_report_id],
                                :user => current_user)
    unless params[:receipt_ids].nil?
      params[:receipt_ids].each do |receipt_id|
        receipt = current_user.receipts.find(receipt_id)
        receipt.expensed = true
        receipt.expense_report = @report
        receipt.save
      end
    end
    
    if @report.save
      redirect_to @report
    end
  end
  
  # UNTESTED SPIKE
  def download_csv
    service = ReportService.new
    report = current_user.expense_reports.find(params[:id])
    receipt_ids = report.receipts.collect { |r| r.id }
    file_name = service.export_expense_report_as_csv(receipt_ids)
    file = File.open(file_name, "r")
    send_file file
    file.close
  end
end
