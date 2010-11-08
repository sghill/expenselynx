class AddDefaultToExpensedOnReceipts < ActiveRecord::Migration
  def self.up
    change_column :receipts, :expensed, :boolean, :default => false
  end

  def self.down
    change_column :receipts, :expensed, :boolean
  end
end
