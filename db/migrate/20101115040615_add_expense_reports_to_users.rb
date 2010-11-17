class AddExpenseReportsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :expense_report_id, :integer
  end

  def self.down
    remove_column :users, :expense_report_id
  end
end
