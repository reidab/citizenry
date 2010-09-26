class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :twitter
      t.string :url
      t.text :bio

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
