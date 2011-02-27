class AddLocationToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :location, :string
  end

  def self.down
    remove_column :people, :location
  end
end
