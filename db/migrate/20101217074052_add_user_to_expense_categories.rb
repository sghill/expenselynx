class AddUserToExpenseCategories < ActiveRecord::Migration
  def self.up
    add_column :expense_categories, :user_id, :integer
  end

  def self.down
    remove_column :expense_categories, :user_id
  end
end
