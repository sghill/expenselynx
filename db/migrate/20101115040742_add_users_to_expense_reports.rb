class AddUsersToExpenseReports < ActiveRecord::Migration
  def self.up
    add_column :expense_reports, :user_id, :integer
  end

  def self.down
    remove_column :expense_reports, :user_id
  end
end
