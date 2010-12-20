class RemoveUserIdFromExpenseCategory < ActiveRecord::Migration
  def self.up
    remove_column :expense_categories, :user_id
  end

  def self.down
    add_column :expense_categories, :user_id, :integer
  end
end
