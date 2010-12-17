class ExpenseCategory < ActiveRecord::Base
  has_many :stores
  has_many :user_store_expense_categories
  has_many :expense_categories, :through => :user_store_expense_categories
  
  validates :name, :presence => true
  
  
  CATEGORIES = ["Hotel", "Local Transportation", "Airfare", "Business Meals"]
end
