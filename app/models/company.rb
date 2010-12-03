class Company < ActiveRecord::Base
  has_and_belongs_to_many :projects

  has_many :sponsorships
  has_many :groups, :through => :sponsorships

  has_many :employments
  has_many :people, :through => :employments

  validates_presence_of :name
end

# == Schema Information
#
# Table name: companies
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  url         :string(255)
#  twitter     :string(255)
#  address     :text
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  logo_url    :string(255)
#

