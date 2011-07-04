class RemoveExpensedFromReceipts < ActiveRecord::Migration
  def self.up
    remove_column :receipts, :expensed
  end

  def self.down
    add_column :receipts, :expensed, :boolean
  end
end
