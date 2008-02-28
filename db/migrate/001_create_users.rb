class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :department_id
      t.string :login
      t.string :first_name, :last_name, :email
      t.string :crypted_password, :salt, :limit => 40
      t.string :remember_token, :remember_token_expires_at
      t.timestamps 
    end
  end

  def self.down
    drop_table :users
  end
end