class AddVersionsToContent < ActiveRecord::Migration
  def self.up
	# create_versioned_table takes the same options hash
    # that create_table does
  	Content.create_versioned_table
  end

  def self.down
  	Content.drop_versioned_table
  end
end
