class CreateIterations < ActiveRecord::Migration
  def self.up
    create_table :iterations do |t|
      t.date :started_at
      t.date :ended_at
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :iterations
  end
end
