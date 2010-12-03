class ExpenseCategory < ActiveRecord::Base
  has_many :stores
  
  validates :name, :presence => true
end
