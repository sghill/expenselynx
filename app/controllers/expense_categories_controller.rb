class ExpenseCategoriesController < ApplicationController
  #TODO: protect this for admin only
  respond_to :html

  def index
    respond_with(@expense_categories = ExpenseCategory.all)
  end
  
  def show
    respond_with(@expense_category = ExpenseCategory.find(params[:id]))
  end
  
  def edit
    respond_with(@expense_category = ExpenseCategory.find(params[:id]))
  end
  
  def update
    @expense_category = ExpenseCategory.find(params[:id])
    @expense_category.update_attributes(params[:expense_category])
    respond_with(@expense_category)
  end
end
