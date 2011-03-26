class ConvertPeopleProjectsToHasMany < ActiveRecord::Migration
  def self.up
    add_column :people_projects, :id, :primary_key
    rename_table :people_projects, :project_memberships
  end

  def self.down
    rename_table :project_memberships, :people_projects
    remove_column :people_projects, :id
  end
end
