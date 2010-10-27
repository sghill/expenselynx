class Store < ActiveRecord::Base
  has_many :receipts
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  
  def self.find_or_create_by_name(*args)
    options = args.extract_options!
    options[:name] = args[0] if args[0].is_a?(String)
    case_sensitive = options.delete(:case_sensitive)
    conditions = case_sensitive ? ['name = ?', options[:name]] : 
                                  ['LOWER(name) = ?', options[:name].downcase]
    first(:conditions => conditions) || create(options)
  end
  
  def self.find_by_name(*args)
    options = args.extract_options!
    options[:name] = args[0] if args[0].is_a?(String)
    case_sensitive = options.delete(:case_sensitive)
    conditions = case_sensitive ? ['name = ?', options[:name]] :
                                  ['LOWER(name) = ?', options[:name].downcase]
    first(:conditions => conditions)
  end
  
  def self.find_all_by_name(*args)
    options = args.extract_options!
    options[:name] = args[0] if args[0].is_a?(String)
    case_sensitive = options.delete(:case_sensitive)
    conditions = case_sensitive ? ['name = ?', options[:name]] :
                                  ['LOWER(name) = ?', options[:name].downcase]
    all(:conditions => conditions)
  end
end
