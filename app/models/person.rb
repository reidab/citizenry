class Person < ActiveRecord::Base
  belongs_to :user

  has_and_belongs_to_many :projects

  has_many :group_memberships
  has_many :groups, :through => :group_memberships

  has_many :employments
  has_many :companies, :through => :employments

  validates_presence_of :first_name, :last_name
end

# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  twitter    :string(255)
#  url        :string(255)
#  bio        :text
#  created_at :datetime
#  updated_at :datetime
#

