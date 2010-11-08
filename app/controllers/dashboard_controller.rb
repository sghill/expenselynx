class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => :index
  def index
    @receipt = Receipt.new
    @receipts = current_user.receipts.find(:all, :limit => 5)
    @stats = {:total => current_user.receipts.sum('total'),
              :unexpensed_total => current_user.receipts.sum('total', :conditions => ["expensable = ?", true])}
  end

end
