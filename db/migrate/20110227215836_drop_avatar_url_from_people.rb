class DropAvatarUrlFromPeople < ActiveRecord::Migration
  def self.up
    Person.all.each do |person|
      person.photo_import_url = person.avatar_url
      person.save!
    end
    remove_column :people, :avatar_url
  end

  def self.down
  end
end
