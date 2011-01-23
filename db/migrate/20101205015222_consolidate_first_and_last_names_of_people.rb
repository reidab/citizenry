class ConsolidateFirstAndLastNamesOfPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :name, :string
    Person.reset_column_information
    Person.all.each do |person|
      person.name = [person.first_name, person.last_name].join(' ')
      person.save!
    end
    remove_column :people, :first_name
    remove_column :people, :last_name
  end

  def self.down
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    Person.reset_column_information
    Person.all.each do |person|
      person.first_name, person.last_name = person.name.split(' ',2)
      person.save!
    end
    remove_column :people, :name
  end
end
