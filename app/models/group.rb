class Group < ActiveRecord::Base
end

# == Schema Information
#
# Table name: groups
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  description  :text
#  url          :string(255)
#  mailing_list :string(255)
#  twitter      :string(255)
#  meeting_info :text
#  created_at   :datetime
#  updated_at   :datetime
#

