class AddDescriptionToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :description, :text
  end
end
