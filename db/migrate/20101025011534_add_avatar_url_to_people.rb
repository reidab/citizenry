class AddAvatarUrlToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :avatar_url, :string
  end

  def self.down
    remove_column :people, :avatar_url
  end
end
