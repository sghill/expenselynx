class AddExternalCategoryCodeToExpenseCategories < ActiveRecord::Migration
  def self.up
    add_column :expense_categories, :external_category_code, :string
  end

  def self.down
    remove_column :expense_categories, :external_category_code
  end
end
