class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :access_token
      t.string :access_token_secret
      t.text :info
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
