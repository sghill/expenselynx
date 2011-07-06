class User < ActiveRecord::Base
  has_many :expense_reports
  has_many :receipts
  has_many :participants
  has_many :projects
  has_many :user_store_expense_categories
  has_many :expense_categories, :through => :user_store_expense_categories
  has_one  :preferences

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  after_create :create_preferences


  private
    def create_preferences
      self.preferences = Preferences.new
    end
end
