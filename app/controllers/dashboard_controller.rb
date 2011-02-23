class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :unexpensed, :projects]

  def index
    @receipt = Receipt.default
    @receipts = current_user.receipts
    @reports = current_user.expense_reports.recent
  end

  def unexpensed
    @receipts = current_user.receipts.unexpensed
  end

  def projects
    @projects = current_user.projects
  end
end
