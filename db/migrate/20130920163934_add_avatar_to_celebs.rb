class AddAvatarToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :avatar, :string
  end
end
