class Receipt < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  belongs_to :expense_report
  
  default_scope :order => 'purchase_date DESC'
  
  validates :total, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0.01}
  validate :purchase_date_is_not_in_the_future,
           :store_existence,
           :nonexpensable_receipt_is_not_expensed
           
  attr_reader :store_name
  
  
  def store_name
    self.store.name unless self.store.nil? 
  end
  
  private
    def purchase_date_is_not_in_the_future
      errors.add(:purchase_date, "cannot occur in future") unless
        purchase_date.present? and DateTime.now > purchase_date
    end
    
    def store_existence
      errors.add(:store_id, "does not exist") if Store.find_by_id(store_id).nil?
    end
    
    def nonexpensable_receipt_is_not_expensed
      errors.add(:expensed, "receipt isn't possible unless receipt is marked expensable") if
        expensed? && !expensable?
    end
end
