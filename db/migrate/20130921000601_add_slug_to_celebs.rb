class AddSlugToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :slug, :string
    add_index :celebs, :slug, unique: true
  end
end
