class ExpenseReportController < ApplicationController
  before_filter :authenticate_user!, :only => :show
  
  def show
    @report = current_user.expense_reports.find(params[:id])
  end

end
