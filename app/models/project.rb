class Project < ActiveRecord::Base
  include SearchEngine
  has_paper_trail :ignore => [:delta]
  acts_as_taggable_on :tags, :technologies
  sortable :created_at, :desc

  has_attached_file :logo, :styles => { :medium => '220x220', :thumb => '48x48' }, :url => "/system/:attachment/:id/:style/:safe_filename"

  default_serialization_options :include => { :people => {:include => [:tags, :technologies]}, 
                                              :companies => {:include => [:tags, :technologies]},
                                              :groups  => {:include => [:tags, :technologies]},
                                              :tags => {},
                                              :technologies => {}}

  import_image_from_url_as :logo

  customizable_slug_from :name

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
#  delta             :boolean(1)      default(TRUE), not null
#

