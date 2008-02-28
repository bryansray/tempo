class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :team_id, :user_id, :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
