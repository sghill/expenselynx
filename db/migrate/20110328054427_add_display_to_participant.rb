class AddDisplayToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :display, :boolean, :default => true
  end

  def self.down
    remove_column :participants, :display
  end
end
