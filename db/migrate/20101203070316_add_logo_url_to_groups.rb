class AddLogoUrlToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :logo_url, :string
  end

  def self.down
    remove_column :groups, :logo_url
  end
end
