class AddMentorFieldsToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :interested_mentor, :boolean
    add_column :people, :interested_mentee, :boolean
    add_column :people, :mentor_topics, :text
    add_column :people, :mentee_topics, :text
  end

  def self.down
    remove_column :people, :mentee_topics
    remove_column :people, :mentor_topics
    remove_column :people, :interested_mentee
    remove_column :people, :interested_mentor
  end
end
