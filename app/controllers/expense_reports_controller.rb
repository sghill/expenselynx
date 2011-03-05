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
