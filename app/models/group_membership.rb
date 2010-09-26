class GroupMembership < ActiveRecord::Base
  belongs_to :group
  belongs_to :person
end

# == Schema Information
#
# Table name: group_memberships
#
#  id              :integer         not null, primary key
#  group_id        :integer
#  person_id       :integer
#  membership_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

