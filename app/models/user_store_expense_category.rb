class UserStoreExpenseCategory < ActiveRecord::Base
  belongs_to :expense_category
  belongs_to :user
  belongs_to :store
end
