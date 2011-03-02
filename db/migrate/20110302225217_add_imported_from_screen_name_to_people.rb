class AddImportedFromScreenNameToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :imported_from_screen_name, :string
  end

  def self.down
    remove_column :people, :imported_from_screen_name
  end
end
