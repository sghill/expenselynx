class AddCounterCacheForReceiptsToExpenseReports < ActiveRecord::Migration
  def self.up
    add_column :expense_reports, :receipts_count, :integer, :default => 0
    
    ExpenseReport.all.each do |report|
      ExpenseReport.reset_counters report.id, :receipts
    end
  end

  def self.down
    remove_column :expense_reports, :receipts_count
  end
end
