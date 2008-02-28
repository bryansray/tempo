class AddPublishedColumnToContentTable < ActiveRecord::Migration
  def self.up
	add_column(:contents, :published, :boolean)
	add_column(:content_versions, :published, :boolean)
  end

  def self.down
	remove_column(:contents, :published)
	remove_column(:content_versions, :published)
  end
end