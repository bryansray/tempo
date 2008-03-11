class ChangeDescriptionColumnTypeInCards < ActiveRecord::Migration
   def self.up
    change_column :cards, :description, :text  
  end

  def self.down
    change_column :cards, :description, :string  
  end
end
