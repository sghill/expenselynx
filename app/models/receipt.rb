class Receipt < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  belongs_to :expense_report
  has_and_belongs_to_many :participants

  default_scope :order => 'purchase_date DESC'

  validates :total, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0.01}
  validates :user, :presence => true
  validate :purchase_date_is_not_in_the_future,
           :store_existence,
           :nonexpensable_receipt_is_not_expensed,
           :nonexpensable_receipt_is_not_member_of_expense_report

  scope :unexpensed, :conditions => {:expensable => true, :expensed => false}
  scope :expensed, :conditions => {:expensed => true}
  scope :unexpensable, :conditions => {:expensable => false}
  scope :recent, :limit => 5, :order => ['created_at DESC']

  def self.default
    self.new(:purchase_date => Time.current.to_date)
  end

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

    def nonexpensable_receipt_is_not_member_of_expense_report
      errors.add(:expense_report_id, "receipt is not marked expensable") if
        !expensable? && expense_report.present?
    end
end
