class Scan < ActiveRecord::Base
  attr_accessible :html, :last_scan, :url
end
