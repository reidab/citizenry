class AddSlugs < ActiveRecord::Migration
  TABLES = %w[people companies projects groups]

  def self.up
    for table in TABLES
      add_column table, :slug, :string
      add_index table,  :slug, :unique => true

      # Add slug to all records
      table.classify.constantize.find_each(&:save)
    end
  end

  def self.down
    for table in TABLES
      remove_index table,  :slug
      remove_column table, :slug
    end
  end
end
