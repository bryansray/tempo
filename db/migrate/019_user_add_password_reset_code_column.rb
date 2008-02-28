class UserAddPasswordResetCodeColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :password_reset_code, :integer
  end

  def self.down
    remove_column :users, :password_reset_code
  end
end
