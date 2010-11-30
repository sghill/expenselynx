class AddReceiptImagesToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :receipt_image, :string
  end

  def self.down
    remove_column :receipts, :receipt_image
  end
end
