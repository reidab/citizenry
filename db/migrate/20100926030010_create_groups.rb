class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :mailing_list
      t.string :twitter
      t.text :meeting_info

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
