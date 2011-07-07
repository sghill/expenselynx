class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :expense_reports
  
  validates :name, :presence => true
  
  scope :current, where(:current => true)
end