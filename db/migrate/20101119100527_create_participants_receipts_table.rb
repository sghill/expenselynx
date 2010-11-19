class CreateParticipantsReceiptsTable < ActiveRecord::Migration
  def self.up
    create_table :participants_receipts, :id => false do |t|
      t.integer :participant_id
      t.integer :receipt_id
    end
  end

  def self.down
    drop_table :participants_receipts
  end
end
