class Receipt < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  
  default_scope :order => 'created_at DESC'
  
  validates :total, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0.01}
  validate :purchase_date_is_not_in_the_future,
           :store_existence
           
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
end
