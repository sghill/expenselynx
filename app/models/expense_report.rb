class ExpenseReport < ActiveRecord::Base
  has_many :receipts
end
