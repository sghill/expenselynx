class StoresController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :search
  
  def edit
    @store = Store.find(params[:id])
    @expense_categories = ExpenseCategory.for_user_and_store(current_user.id, params[:id])
  end
  
  def update
    @store = Store.find(params[:id])
    expense_category_name = params[:store][:expense_categories]
    unless expense_category_name.nil?
      old_category = ExpenseCategory.find_by_name(expense_category_name)
      if old_category.nil?
        cat5e = ExpenseCategory.create(:name => expense_category_name)
        UserStoreExpenseCategory.create(:expense_category => cat5e, :user => current_user, :store => @store)
        @store.expense_categories.build(cat5e)
      else
        UserStoreExpenseCategory.create(:expense_category => old_category, :user => current_user, :store => @store) #untested
        @store.expense_categories.build(old_category)
      end
      
      @store.save
    end
    redirect_to dashboard_index_path
  end
  
  def show
    @store = Store.find(params[:id])
    @expense_categories = ExpenseCategory.for_user_and_store(current_user.id, params[:id])
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
