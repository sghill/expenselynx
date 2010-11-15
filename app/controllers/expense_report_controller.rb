class ExpenseReportController < ApplicationController
  def show
    @report = ExpenseReport.find(params[:id])
  end

end
