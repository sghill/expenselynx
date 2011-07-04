class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @receipts = current_user.receipts
    @reports = current_user.expense_reports.recent
  end
end
