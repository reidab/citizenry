class AddLogoUrlToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :logo_url, :string
  end

  def self.down
    remove_column :companies, :logo_url
  end
end
