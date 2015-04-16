class FixImageColumnName < ActiveRecord::Migration
  def change
    remove_column :celebs, :image
    add_column :celebs, :avatar_present, :boolean
  end
end
