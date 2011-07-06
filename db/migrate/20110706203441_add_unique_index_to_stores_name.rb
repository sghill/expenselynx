class AddUniqueIndexToStoresName < ActiveRecord::Migration
  def self.up
    add_index(:stores, [:name], :name => 'index_stores_on_name', :unique => true)
  end

  def self.down
    remove_index(:stores, 'index_stores_on_name')
  end
end
