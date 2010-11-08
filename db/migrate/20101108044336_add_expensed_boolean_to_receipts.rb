class AddExpensedBooleanToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :expensed, :boolean
  end

  def self.down
    remove_column :receipts, :expensed, :boolean
  end
end
