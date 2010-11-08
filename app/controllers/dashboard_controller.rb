class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => :index
  def index
    @receipt = Receipt.new(:purchase_date => Time.now.to_date)
    @receipts = current_user.receipts.find(:all, :limit => 5)
    @stats = {:total => current_user.receipts.sum('total').to_f,
              :unexpensed_total => current_user.receipts.sum('total', :conditions => ["expensable = ? AND expensed = ?", true, false]).to_f,
              :expensed_total => current_user.receipts.sum('total', :conditions => ["expensed = ?", true]).to_f}
  end

end
