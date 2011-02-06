class AddNameToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :name, :string
  end

  def self.down
    remove_column :projects, :name
  end
end
