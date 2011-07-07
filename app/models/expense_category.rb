class ExpenseCategory < ActiveRecord::Base
  has_many :user_store_expense_categories
  has_many :stores, :through => :user_store_expense_categories
  has_many :users, :through => :user_store_expense_categories

  validates :name, :presence => true

  scope :for_user_and_store, lambda { |user_id, store_id| {:joins => [:user_store_expense_categories], :conditions => {:user_store_expense_categories => {:user_id => user_id, :store_id => store_id}}} }

end
