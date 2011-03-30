class AddDeltaColumnsToIndexedModels < ActiveRecord::Migration
  def self.up
    add_column :people,    :delta, :boolean, :default => true, :null => false
    add_column :companies, :delta, :boolean, :default => true, :null => false
    add_column :projects,  :delta, :boolean, :default => true, :null => false
    add_column :groups,    :delta, :boolean, :default => true, :null => false
    add_column :resource_links, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :people,    :delta
    remove_column :companies, :delta
    remove_column :projects,  :delta
    remove_column :groups,    :delta
    remove_column :resources, :delta
  end
end
