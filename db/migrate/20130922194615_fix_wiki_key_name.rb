class FixWikiKeyName < ActiveRecord::Migration
  def up
    rename_column :celebs, :wiki_key, :wiki_name
  end

  def down
  end
end
