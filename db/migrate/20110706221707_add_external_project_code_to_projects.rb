class AddExternalProjectCodeToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :external_project_code, :string
  end

  def self.down
    remove_column :projects, :external_project_code
  end
end
