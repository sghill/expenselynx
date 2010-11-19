class Participant < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  validates :name, :presence => true
end
