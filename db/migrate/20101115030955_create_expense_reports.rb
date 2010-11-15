class CreateExpenseReports < ActiveRecord::Migration
  def self.up
    create_table :expense_reports do |t|
      t.string :external_report_id

      t.timestamps
    end
  end

  def self.down
    drop_table :expense_reports
  end
end
