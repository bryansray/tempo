class AddOrderColumnToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :position, :int
  end

  def self.down
    remove_column :links, :position
  end
end
