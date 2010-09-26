class GroupsProjects < ActiveRecord::Migration
  def self.up
    create_table :groups_projects, :id => false do |t|
      t.belongs_to :group, :project
      t.timestamps
    end
  end

  def self.down
    drop_table :groups_projects
  end
end
