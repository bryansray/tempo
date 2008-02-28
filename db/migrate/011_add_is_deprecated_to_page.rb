class AddIsDeprecatedToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :deprecated, :boolean  
  end

  def self.down
    remove_column :pages, :deprecated  
  end
end
