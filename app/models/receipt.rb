class Receipt < ActiveRecord::Base
  validates :total, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0.01}
  validate :purchase_date_is_not_in_the_future,
           :store_existence
  
  
  private
    def purchase_date_is_not_in_the_future
      errors.add(:purchase_date, "Receipt cannot occur in future") unless
        purchase_date.present? and DateTime.now > purchase_date
    end
    
    def store_existence
      errors.add(:store_id, "Store does not exist") if Store.find_by_id(store_id).nil?
    end
end
