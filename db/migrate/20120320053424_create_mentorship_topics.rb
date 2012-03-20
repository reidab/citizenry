class CreateMentorshipTopics < ActiveRecord::Migration
  def change
    create_table :mentorship_topics do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end

    create_table :person_mentor_topics do |t|
      t.belongs_to :person
      t.belongs_to :mentorship_topic
    end

    create_table :person_mentee_topics do |t|
      t.belongs_to :person
      t.belongs_to :mentorship_topic
    end
  end
end
