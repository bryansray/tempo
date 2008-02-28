class AddDefaultOptionToPropertiesTable < ActiveRecord::Migration
   def self.up
    add_column :properties, :default_option, :integer  
  end

  def self.down
    remove_column :properties, :default_option  
  end
end
