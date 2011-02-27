class Sponsorship < ActiveRecord::Base
  has_paper_trail

  belongs_to :company
  belongs_to :group
end


# == Schema Information
#
# Table name: sponsorships
#
#  id               :integer(4)      not null, primary key
#  group_id         :integer(4)
#  company_id       :integer(4)
#  sponsorship_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

