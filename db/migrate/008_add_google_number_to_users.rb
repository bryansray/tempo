class AddGoogleNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :google_number, :string
  end

  def self.down
    remove_column :users, :google_number
  end
end