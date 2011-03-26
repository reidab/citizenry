class ConvertGroupProjectsToHasToMany < ActiveRecord::Migration
  def self.up
    add_column :groups_projects, :id, :primary_key
    rename_table :groups_projects, :group_projects
  end

  def self.down
    rename_table :group_projects, :groups_projects
    remove_column :groups_projects, :id
  end
end
