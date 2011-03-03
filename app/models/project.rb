class Project < ActiveRecord::Base
  has_paper_trail
  acts_as_taggable_on :tags, :technologies

  has_attached_file :logo, :styles => { :medium => '220x220', :thumb => '48x48' }

  default_scope order('created_at DESC')

  has_and_belongs_to_many :people
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :companies

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

