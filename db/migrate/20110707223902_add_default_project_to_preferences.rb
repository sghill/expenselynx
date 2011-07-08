class AddDefaultProjectToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :default_project_id, :integer
  end

  def self.down
    remove_column :preferences, :default_project_id
  end
end
