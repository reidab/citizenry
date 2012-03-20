class MentorshipTopic < ActiveRecord::Base
  has_many :person_mentor_topics
  has_many :person_mentee_topics
  has_many :mentors, :through => :person_mentor_topics, :source => :person
  has_many :mentees, :through => :person_mentee_topics, :source => :person

  def humanize
    name || slug
  end
end
