class AddReviewedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :reviewed, :boolean, :default => false
  end

  def self.down
    remove_column :people, :reviewed
  end
end
