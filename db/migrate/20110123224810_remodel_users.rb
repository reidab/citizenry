class RemodelUsers < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table :users do |t|
      #t.database_authenticatable
      #t.confirmable
      #t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
      t.boolean :admin, :default => false
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration    
  end
end
