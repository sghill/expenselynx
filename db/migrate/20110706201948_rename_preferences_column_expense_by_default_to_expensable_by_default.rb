class RenamePreferencesColumnExpenseByDefaultToExpensableByDefault < ActiveRecord::Migration
  def self.up
    rename_column(:preferences, :expense_by_default, :expensable_by_default)
  end

  def self.down
    rename_column(:preferences, :expensable_by_default, :expense_by_default)
  end
end
