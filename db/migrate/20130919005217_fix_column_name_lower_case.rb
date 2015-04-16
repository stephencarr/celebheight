class FixColumnNameLowerCase < ActiveRecord::Migration
  def up
    rename_column :celebs, :TwitterId, :twitter_id
    rename_column :celebs, :Image, :image
    rename_column :celebs, :FullName, :full_name
    rename_column :celebs, :FirstName, :first_name
    rename_column :celebs, :LastName, :last_name
    rename_column :celebs, :MetricHeight, :metric_height
    rename_column :celebs, :Tweets, :tweets
    rename_column :scans, :lastScan, :last_scan
  end

  def down
  end
end
