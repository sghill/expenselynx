class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => :index
  def index
    @receipt = Receipt.new
    @receipts = current_user.receipts.find(:all, :limit => 5)
  end

end
