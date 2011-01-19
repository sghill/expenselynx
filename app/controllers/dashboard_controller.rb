class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :unexpensed]

  def index
    @receipt = Receipt.new(:purchase_date => Time.now.to_date)
    @receipts = current_user.receipts
    @reports = current_user.expense_reports.find(:all, :limit => 5, :order => 'created_at DESC')
  end

  def unexpensed
    @receipts = current_user.receipts.unexpensed
  end
end
