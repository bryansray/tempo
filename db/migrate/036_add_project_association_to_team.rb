class AddProjectAssociationToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :project_id, :int
  end

  def self.down
    remove_column :teams, :project_id
  end
end
