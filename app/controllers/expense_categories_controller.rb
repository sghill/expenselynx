class ExpenseCategoriesController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]

  respond_to :html

  def index
    respond_with(@expense_categories = ExpenseCategory.all)
  end
  
  def show
    @expense_category = ExpenseCategory.find(params[:id])
    receipts = current_user.receipts.where(:store_id => @expense_category.stores).order('created_at')
    @receipt_count = receipts.count
    @recent_receipts = receipts.take(5)
    respond_with(@expense_category, @receipts)
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
