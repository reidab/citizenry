class Project < ActiveRecord::Base
  has_paper_trail
  acts_as_taggable_on :tags, :technologies

  has_attached_file :logo, :styles => { :medium => '220x220', :thumb => '48x48' }

  default_scope order('projects.created_at DESC')

  has_many :project_memberships
  has_many :people, :through => :project_memberships

  has_many :company_projects
  has_many :companies, :through => :company_projects

  has_many :group_projects
  has_many :groups, :through => :group_projects

  validates_presence_of :name
end



# == Schema Information
#
# Table name: projects
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  url               :string(255)
#  twitter           :string(255)
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

