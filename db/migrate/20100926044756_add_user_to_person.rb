class AddUserToPerson < ActiveRecord::Migration
  def self.up
    add_column :person, :user_id, :integer
  end

  def self.down
    remove_column :person, :user_id
  end
end
