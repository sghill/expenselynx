class AddUserIdToReceipt < ActiveRecord::Migration
  def self.up
    add_column :receipts, :user_id, :integer
  end

  def self.down
    remove_column :receipts, :user_id
  end
end
