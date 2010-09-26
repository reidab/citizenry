class Employment < ActiveRecord::Base
  belongs_to :person
  belongs_to :company
end

# == Schema Information
#
# Table name: employments
#
#  id         :integer         not null, primary key
#  person_id  :integer
#  company_id :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

