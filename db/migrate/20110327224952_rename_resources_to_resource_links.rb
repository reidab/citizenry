class RenameResourcesToResourceLinks < ActiveRecord::Migration
  def self.up
    rename_table :resources, :resource_links
  end

  def self.down
    rename_table :resource_links, :resources
  end
end
