class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.integer :project_id
      
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :types
  end
end
