class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.integer :group_id
      t.integer :company_id
      t.string :sponsorship_type

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
