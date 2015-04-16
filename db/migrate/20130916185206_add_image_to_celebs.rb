class AddImageToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :image, :text
  end
end
