class Project < ActiveRecord::Base
end

# == Schema Information
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  url         :string(255)
#  twitter     :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

