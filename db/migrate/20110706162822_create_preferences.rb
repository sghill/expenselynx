class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.boolean :expense_by_default

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
