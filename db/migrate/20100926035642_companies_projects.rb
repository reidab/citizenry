class CompaniesProjects < ActiveRecord::Migration
  def self.up
    create_table :companies_projects, :force => true, :id => false do |t|
      t.belongs_to :company
      t.belongs_to :project
      t.timestamps
    end
  end

  def self.down
    drop_table :companies_projects
  end
end
