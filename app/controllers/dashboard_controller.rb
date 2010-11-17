class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => :index
  def index
    @receipt = Receipt.new(:purchase_date => Time.now.to_date)
    @receipts = current_user.receipts.find(:all, :limit => 5)
    @stats = {:total => current_user.receipts.sum(:total).to_f,
              :unexpensed_total => unexpensed_receipts.sum(:total).to_f,
              :expensed_total => current_user.receipts.sum(:total, :conditions => ["expensed = ?", true]).to_f}
    @reports = current_user.expense_reports.find(:all, :limit => 5)
  end
  
  def unexpensed
    @receipts = unexpensed_receipts
  end

  private
    def unexpensed_receipts
      return current_user.receipts.where(:expensable => true, :expensed => false)
    end
end
