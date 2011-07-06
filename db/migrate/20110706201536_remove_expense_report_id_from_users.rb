class RemoveExpenseReportIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :expense_report_id
  end

  def self.down
    add_column :users, :expense_report_id, :integer
  end
end
