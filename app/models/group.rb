class Group < ActiveRecord::Base
  has_and_belongs_to_many :projects

  has_many :group_memberships
  has_many :people, :through => :group_memberships

  has_many :sponsorships
  has_many :companies, :through => :sponsorships

  validates_presence_of :name
end

# == Schema Information
#
# Table name: groups
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :text
#  url          :string(255)
#  mailing_list :string(255)
#  twitter      :string(255)
#  meeting_info :text
#  created_at   :datetime
#  updated_at   :datetime
#  logo_url     :string(255)
#

