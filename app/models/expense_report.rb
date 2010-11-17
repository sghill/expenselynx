class ExpenseReport < ActiveRecord::Base
  has_many :receipts
  belongs_to :user
  
  validates :user, :presence => true
end
