class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string :name
      t.string :description

	  # These fields are responsible for the polymorphic relationships
	  # from other models that define property scopes
	  t.integer :scope_id
	  t.string :scope_type
		
      t.timestamps
    end
  end

  def self.down
    drop_table :properties
  end
end
