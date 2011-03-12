class AddCurrencyToReceiptTotal < ActiveRecord::Migration
  def self.up
    add_column :receipts, :total_cents, :integer
    add_column :receipts, :total_currency, :string
  end

  def self.down
    remove_column :receipts, :total_cents
    remove_column :receipts, :total_currency
  end
end
