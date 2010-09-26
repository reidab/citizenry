class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :url
      t.string :twitter
      t.text :address
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
