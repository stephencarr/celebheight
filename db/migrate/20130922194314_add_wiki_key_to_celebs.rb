class AddWikiKeyToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :wiki_key, :string
  end
end
