class AddSlugsToModels < ActiveRecord::Migration
  def self.up
		add_column :people, :slug, :string
 		add_column :companies, :slug, :string
		add_column :projects, :slug, :string
		add_column :groups, :slug, :string

		add_index :people, :slug, :unique => true
		add_index :companies, :slug, :unique => true
		add_index :projects, :slug, :unique => true
		add_index :groups, :slug, :unique => true
  end

  def self.down
		remove_index :people, :slug
		remove_index :companies, :slug
		remove_index :projects, :slug
		remove_index :groups, :slug

    remove_column :people, :slug
    remove_column :companies, :slug
    remove_column :projects, :slug
    remove_column :groups, :slug
  end
end
