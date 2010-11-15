class AddExpenseReportIdToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :expense_report_id, :integer
  end

  def self.down
    remove_column :receipts, :expense_report_id
  end
end
