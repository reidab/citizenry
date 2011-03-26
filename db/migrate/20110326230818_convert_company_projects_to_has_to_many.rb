class ConvertCompanyProjectsToHasToMany < ActiveRecord::Migration
  def self.up
    add_column :companies_projects, :id, :primary_key
    rename_table :companies_projects, :company_projects
  end

  def self.down
    rename_table :company_projects, :companies_projects
    remove_column :companies_projects, :id
  end
end
