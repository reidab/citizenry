class ProjectMembership < ActiveRecord::Base
  has_paper_trail

  belongs_to :project
  belongs_to :person
end

# == Schema Information
#
# Table name: project_memberships
#
#  id         :integer(4)      not null, primary key
#  person_id  :integer(4)
#  project_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

