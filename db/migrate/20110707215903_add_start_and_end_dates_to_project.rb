class AddStartAndEndDatesToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :start_date, :date
    add_column :projects, :end_date, :date
  end

  def self.down
    remove_column :projects, :end_date
    remove_column :projects, :start_date
  end
end
