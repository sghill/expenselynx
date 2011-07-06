class AddProjectIdToExpenseReports < ActiveRecord::Migration
  def self.up
    add_column :expense_reports, :project_id, :integer
  end

  def self.down
    remove_column :expense_reports, :project_id
  end
end
