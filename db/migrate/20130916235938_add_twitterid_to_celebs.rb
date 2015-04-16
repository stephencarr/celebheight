class AddTwitteridToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :twitterid, :string
  end
end
