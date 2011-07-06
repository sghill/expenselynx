class AddDefaultPreferencesToEachUser < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.preferences = Preferences.new(:user => user)
      user.save!
    end
  end

  def self.down
    User.all.each do |user|
      user.preferences = nil
      user.save!
    end
  end
end
