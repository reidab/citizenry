class CompanyProject < ActiveRecord::Base
  has_paper_trail

  belongs_to :project
  belongs_to :company
end

# == Schema Information
#
# Table name: company_projects
#
#  company_id :integer(4)
#  project_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  id         :integer(4)      not null, primary key
#

