class Sponsorship < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
end

# == Schema Information
#
# Table name: sponsorships
#
#  id               :integer         not null, primary key
#  group_id         :integer
#  company_id       :integer
#  sponsorship_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

