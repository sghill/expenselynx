class Store < ActiveRecord::Base
  has_many :receipts
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
end
