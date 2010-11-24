class Participant < ActiveRecord::Base
  has_and_belongs_to_many :receipts
  belongs_to :user
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates :user, :presence => true
  
  def self.find_or_create_by_name(*args)
    options = args.extract_options!
    options[:name] = args[0] if args[0].is_a?(String)
    case_sensitive = options.delete(:case_sensitive)
    conditions = case_sensitive ? ['name = ?', options[:name]] : 
                                  ['LOWER(name) = ?', options[:name].downcase]
    first(:conditions => conditions) || create(options)
  end
end
