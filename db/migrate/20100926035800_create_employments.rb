class CreateEmployments < ActiveRecord::Migration
  def self.up
    create_table :employments do |t|
      t.integer :person_id
      t.integer :company_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :employments
  end
end
