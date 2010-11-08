class ChangePurchaseDateToDateOnReceipts < ActiveRecord::Migration
  def self.up
    change_column :receipts, :purchase_date, :date
  end

  def self.down
    change_column :receipts, :purchase_date, :datetime
  end
end
