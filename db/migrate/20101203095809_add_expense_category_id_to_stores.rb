class AddExpenseCategoryIdToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :expense_category_id, :integer
  end

  def self.down
    remove_column :stores, :expense_category_id
  end
end
