class AddImportedFromInfoToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :imported_from_provider, :string
    add_column :people, :imported_from_id, :string
  end

  def self.down
    remove_column :people, :imported_from_id
    remove_column :people, :imported_from_provider
  end
end
