class ChangeAvatarPresent < ActiveRecord::Migration
  def up
    rename_column :celebs, :avatar_present, :scanned
    change_column :celebs, :scanned, :boolean, :default => false
  end

  def down
  end
end
