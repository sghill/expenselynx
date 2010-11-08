class AddDefaultToExpensableInReceipts < ActiveRecord::Migration
  def self.up
    change_column :receipts, :expensable, :boolean, :default => false
  end

  def self.down
    change_column :receipts, :expensable, :boolean
  end
end
