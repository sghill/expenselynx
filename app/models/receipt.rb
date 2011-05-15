class Receipt < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  belongs_to :expense_report
  has_and_belongs_to_many :participants
  composed_of :total_money,
    :class_name => "Money",
    :mapping => [%w(total_cents cents), %w(total dollars), %w(total_currency currency_as_string)],
    :constructor => Proc.new { |cents, dollars, currency| Money.new(dollars.to_f * 100 || 0, currency || "USD") },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  default_scope :order => 'purchase_date DESC'

  validates :total, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0.01}
  validates :user, :presence => true
  validates :purchase_date, :presence => true
  validate :store_existence,
           :nonexpensable_receipt_is_not_expensed,
           :nonexpensable_receipt_is_not_member_of_expense_report

  scope :unexpensed, :conditions => { :expensable => true, :expense_report_id => nil }
  scope :expensed, :conditions => ['expense_report_id IS NOT NULL']
  scope :unexpensable, :conditions => { :expensable => false }
  scope :recent, :limit => 5, :order => ['created_at DESC']

  def expensed?
    expense_report.present?
  end
  
  def total= amount
    if amount
      self[:total] = amount
      self[:total_cents] = 100 * amount.to_f
      self[:total_currency] = "USD"
    end
  end

  def self.default
    self.new(:purchase_date => Time.current.to_date)
  end

  def store_name
    self.store.name unless self.store.nil?
  end
  
  def store_name=(name)
    self.store = Store.find_or_create_by_name(name)
  end
  
  def report exreport
    exreport.receipts << self
    self
  end

  def exportable?
    return !self.store.expense_categories.empty?
  end

  private
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
