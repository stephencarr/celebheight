class AddTweetsToCelebs < ActiveRecord::Migration
  def change
    add_column :celebs, :Tweets, :text
  end
end
