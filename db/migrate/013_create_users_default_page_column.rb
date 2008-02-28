class CreateUsersDefaultPageColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :default_page, :integer
  end

  def self.down
    remove_column :users, :default_page
  end
end
