class Company < ActiveRecord::Base
  include SearchEngine
  has_paper_trail
  acts_as_taggable_on :tags, :technologies
  sortable :created_at, :desc

  has_attached_file :logo, :styles => { :medium => '220x220', :thumb => '48x48' }, :url => "/system/:attachment/:id/:style/:safe_filename"

  default_json_options :include => [:projects, :groups, :employees]

  has_many :company_projects
  has_many :projects, :through => :company_projects

  has_many :sponsorships
  has_many :groups, :through => :sponsorships

  has_many :employments
  has_many :employees, :through => :employments, :source => :person

  validates_presence_of :name

  define_index do
    indexes :name, :sortable => true
    indexes :description
    indexes :url
    indexes :address
    indexes technology_taggings.tag.name, :as => :technologies
    indexes tag_taggings.tag.name, :as => :tags

    has :created_at, :updated_at
    set_property :delta => true
  end
end



# == Schema Information
#
# Table name: companies
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  url               :string(255)
#  twitter           :string(255)
#  address           :text
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#  logo_url          :string(255)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

