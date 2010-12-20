class ExpenseCategory < ActiveRecord::Base
  has_many :user_store_expense_categories
  has_many :stores, :through => :user_store_expense_categories
  has_many :users, :through => :user_store_expense_categories
  
  validates :name, :presence => true
  
  
  CATEGORIES = ["Hotel", "Local Transportation", "Airfare", "Business Meals"]
end
