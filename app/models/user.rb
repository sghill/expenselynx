class User < ActiveRecord::Base
  has_many :expense_reports
  has_many :receipts
  has_many :participants

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
end
