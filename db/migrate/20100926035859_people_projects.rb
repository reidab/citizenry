class PeopleProjects < ActiveRecord::Migration
  def self.up
    create_table :people_projects, :force => true, :id => false do |t|
      t.belongs_to :person
      t.belongs_to :project
      t.timestamps
    end
  end

  def self.down
    drop_table :people_projects
  end
end
