class Preferences < ActiveRecord::Base
  belongs_to :user
  
  def default_project?
    !default_project_id.nil?
  end
end
