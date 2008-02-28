class AddPublishedAtToContentsTable < ActiveRecord::Migration
  def self.up
    remove_column :posts, :published_at
    add_column :contents, :published_at, :timestamp
    add_column :content_versions, :published_at, :timestamp
    
    content = Content.find(:all)
    Content.record_timestamps = false
    content.each { |c| c.published_at = c.updated_at; c.save! }
    Content.record_timestamps = true
  end

  def self.down
    add_column :posts, :published_at, :datetime
    remove_column :contents, :published_at
    remove_column :content_versions, :published_at
  end
end
