class Store < ActiveRecord::Base
  validates :name, :presence => true
end
