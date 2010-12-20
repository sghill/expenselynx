class RemoveExpenseCategoryIdFromStore < ActiveRecord::Migration
  def self.up
    remove_column :stores, :expense_category_id
  end

  def self.down
    add_column :stores, :expense_category_id, :integer
  end
end
