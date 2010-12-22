class Participant < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :user
  
  default_scope :order => 'name ASC'
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates :user, :presence => true
  
  def ==(other)
    return (self.name == other.name) && other.is_a?(Participant)
  end
  
  def self.find_or_create_by_name(*args)
    options = args.extract_options!
    options[:name] = args[0] if args[0].is_a?(String)
    conditions = ['LOWER(name) = ?', options[:name].downcase]
    first(:conditions => conditions) || create(options)
  end
  
  def self.search_by_name(partial_name)
    conditions = ['LOWER(name) LIKE ?', partial_name + '%']
    all(:conditions => conditions)
  end
end
