class AddExpensableToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :expensable, :boolean
  end

  def self.down
    remove_column :receipts, :expensable
  end
end
