class StoresController < ApplicationController
  before_filter :authenticate_user!, :only => :edit
  
  def edit
    @store = Store.find(params[:id])
  end
  
  def update
    @store = Store.find(params[:id])
    @store.update_attributes(:expense_category => ExpenseCategory.find_or_create_by_name(params[:store][:expense_category]))
    redirect_to dashboard_index_path
  end
  
  def search
    if params[:term]
      @stores = Store.search_by_name(params[:term])
    else
      @stores = Store.all
    end
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
