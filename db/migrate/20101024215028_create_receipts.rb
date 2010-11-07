class CreateReceipts < ActiveRecord::Migration
  def self.up
    create_table :receipts do |t|
      t.integer :store_id
      t.datetime :purchase_date
      t.decimal :total, :precision => 10, :scale => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :receipts
  end
end
