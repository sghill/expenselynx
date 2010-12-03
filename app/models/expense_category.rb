class ExpenseCategory < ActiveRecord::Base
  has_many :stores
  
  validates :name, :presence => true
  
  
  CATEGORIES = ["Hotel", "Local Transportation", "Airfare", "Business Meals"]
end
