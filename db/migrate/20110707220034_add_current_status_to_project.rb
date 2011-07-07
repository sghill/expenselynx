class AddCurrentStatusToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :current, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :current
  end
end
