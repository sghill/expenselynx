class AddFrozenStringExpenseCategoriesToDatabase < ActiveRecord::Migration
  def self.up
    all_categories = ["Airfare & Upgrades",
                "Airfare Change Fees",
                "Benefits (Fitness)",
                "Benefits (Transit)",
                "Books",
                "Business Meals",
                "Car Rental",
                "Computer supplies",
                "Conference",
                "Corporate Apartment",
                "Dues & Subscriptions",
                "Entertainment",
                "Fees and Other charges",
                "Gas",
                "Gifts/Incentives",
                "High Speed Internet",
                "Hotel",
                "Local Transportation",
                "Mileage/Parking/Tolls",
                "Office Supplies",
                "Other",
                "Passport/Visa/Immigration",
                "Per Diem/Stipend (pre-approved)",
                "Postage & Shipping",
                "Relocation",
                "Telephone",
                "Training/Education",
                "Travel Medicines/Vaccinations"]
    already_included_categories = ExpenseCategory.all.collect { |category| category.name }
    missing_categories = all_categories.reject { |fc_name| already_included_categories.include? fc_name }
    missing_categories.each do |category_name|
      ExpenseCategory.create(:name => category_name)
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't replace the static list of categories"
  end
end
