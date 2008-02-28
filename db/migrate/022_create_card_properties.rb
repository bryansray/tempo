class CreateCardProperties < ActiveRecord::Migration
  def self.up
    create_table :card_properties do |t|
      t.integer :card_id, :property_id, :option_id
      t.timestamps
    end
  end

  def self.down
    drop_table :card_properties
  end
end
