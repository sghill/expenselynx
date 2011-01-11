class ExpenseCategory < ActiveRecord::Base
  has_many :user_store_expense_categories
  has_many :stores, :through => :user_store_expense_categories
  has_many :users, :through => :user_store_expense_categories
  
  validates :name, :presence => true
  
  
  CATEGORIES = ["Airfare & Upgrades",
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
                "Travel Medicines/Vaccinations"].freeze
end
