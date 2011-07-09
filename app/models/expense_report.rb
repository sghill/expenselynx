class ExpenseReport < ActiveRecord::Base
  has_many :receipts
  belongs_to :project
  belongs_to :user

  validates :user, :presence => true
  scope :recent, order('created_at DESC').limit(5)
  
  attr_accessible :external_report_id, :user, :project_id

  def receipt_count
    return receipts.count
  end

  def receipt_sum
    receipts.map(&:total_money).reduce(:+)
  end
  
  def reset_receipts_count_cache
    ExpenseReport.reset_counters self.id, :receipts
  end
  
  def ==(other)
    if self.nil? || other.nil? 
      return false
    end
    
    self.user == other.user && 
    self.external_report_id == other.external_report_id &&
    self.receipts == other.receipts
  end
end
