class Project < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => '250x250', :thumb => '48x48' }

  has_and_belongs_to_many :people
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :companies

  validates_presence_of :name
end


# == Schema Information
#
# Table name: projects
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  url         :string(255)
#  twitter     :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

