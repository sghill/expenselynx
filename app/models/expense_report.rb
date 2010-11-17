class ExpenseReport < ActiveRecord::Base
  has_many :receipts
  belongs_to :user
  
  validates :user, :presence => true
  
  def receipt_count
    return receipts.count
  end
  
  def receipt_sum
    return receipts.sum(:total)
  end
end
