class AddPublishedColumnToContentTable < ActiveRecord::Migration
  def self.up
	add_column(:contents, :published, :boolean)
  end

  def self.down
	remove_column(:contents, :published)
  end
end
