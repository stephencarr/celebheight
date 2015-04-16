class Celeb < ActiveRecord::Base
  attr_accessible :first_name, :full_name, :last_name, :metric_height, :scanned, :twitter_id, :tweets, :slug, :description, :wiki_name
  attr_accessor :temp
  paginates_per 10

  mount_uploader :avatar, AvatarUploader

  extend FriendlyId
  friendly_id :full_name, use: :slugged

  def self.search(search)
    if search
      str   = URI.unescape(search)
      str = str.gsub('-', ' ')
      parts  = str.split(/\s*,\s*/)
      .map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_').strip }
      .map { |s| '%' + s.strip + '%' }

      where('full_name ilike any(array[?])', parts)

    else
      scoped
    end
  end

end
