class Employment < ActiveRecord::Base
  has_paper_trail

  belongs_to :person
  belongs_to :company
end


# == Schema Information
#
# Table name: employments
#
#  id         :integer(4)      not null, primary key
#  person_id  :integer(4)
#  company_id :integer(4)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

