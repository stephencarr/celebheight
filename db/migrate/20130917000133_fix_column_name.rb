class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :celebs, :twitterid, :TwitterId
    rename_column :celebs, :image, :Image
  end

  def down
    rename_column :celebs, :TwitterId, :twitterid
    rename_column :celebs, :Image, :image
  end
end
