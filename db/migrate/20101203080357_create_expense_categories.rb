class CreateExpenseCategories < ActiveRecord::Migration
  def self.up
    create_table :expense_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :expense_categories
  end
end
