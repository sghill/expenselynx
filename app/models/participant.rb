class Participant < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :user
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates :user, :presence => true
end
