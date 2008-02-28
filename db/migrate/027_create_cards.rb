class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :title, :description
      t.integer :project_id, :iteration_id, :team_id
	  t.float :estimated, :actual

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
