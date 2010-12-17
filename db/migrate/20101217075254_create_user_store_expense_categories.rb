class CreateUserStoreExpenseCategories < ActiveRecord::Migration
  def self.up
    create_table :user_store_expense_categories, :id => false do |t|
      t.integer :user_id
      t.integer :store_id
      t.integer :expense_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_store_expense_categories
  end
end
