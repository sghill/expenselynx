class AddNoteToReceipt < ActiveRecord::Migration
  def self.up
    add_column :receipts, :note, :string
  end

  def self.down
    remove_column :receipts, :note
  end
end
