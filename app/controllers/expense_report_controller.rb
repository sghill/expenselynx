require 'csv'

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
    @receipts = current_user.expense_reports.find(params[:id]).receipts
    csv_string = CSV.generate do |csv|
      @receipts.each do |receipt|
        store = Store.find_by_name(receipt.store.name)
        expense_category = ExpenseCategory.find_by_name(store.expense_category.name)
        participant_names = receipt.participants.collect{ |p| p.name }
        participant_names << "me"
        
        csv << [expense_category.nil? ? "" : expense_category.name,
          receipt.purchase_date,
          receipt.total,
          "USD",
          receipt.note.nil? ? "" : receipt.note,
          store.name,
          "Personal Card",
          participant_names.join("; "),
          false]
      end
    end

    send_data csv_string,
                :type => 'text/csv; charset=utf-8; header=present',
                :disposition => "attachment; filename=myreceipts.csv"
  end
end
