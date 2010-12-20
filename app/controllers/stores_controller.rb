class StoresController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  
  def edit
    @store = Store.find(params[:id])
  end
  
  def update
    @store = Store.find(params[:id])
    unless params[:store][:expense_categories].nil?
      expense_categories = ExpenseCategory.find_or_create_by_name(params[:store][:expense_categories])
      @store.update_attributes!(:expense_categories => [expense_categories])
    end
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
