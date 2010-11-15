class ExpenseReportController < ApplicationController
  before_filter :authenticate_user!, :only => [:show, :create]
  
  def show
    @report = current_user.expense_reports.find(params[:id])
  end
  
  def create
    
  end

end
