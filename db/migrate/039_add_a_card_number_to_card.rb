class AddACardNumberToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :number, :integer
  end

  def self.down
    remove_column :number
  end
end
