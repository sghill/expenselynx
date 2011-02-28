require 'csv'

class ExpenseReportsController < ApplicationController
  before_filter :authenticate_user!, :only => [:show, :create, :download]

  expose(:report) do
    current_user.expense_reports.find(params[:id])
  end

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

  def download
    downloadable and expires_in 30.days
    respond_to do |format|
      format.csv
    end
  end
end
