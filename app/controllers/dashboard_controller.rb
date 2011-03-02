class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :unexpensed]

  def index
    @receipt = Receipt.default
    @receipts = current_user.receipts
    @reports = current_user.expense_reports.recent
  end

  def unexpensed
    @receipts = current_user.receipts.unexpensed
  end
end