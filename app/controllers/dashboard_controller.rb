class DashboardController < ApplicationController

  def index
    @unexpensed = current_user.receipts.unexpensed.inject(Money.new(0)) { |sum, n| n.total_money + sum }
    @receipts = current_user.receipts.recent
    @reports = current_user.expense_reports.recent
  end
end
