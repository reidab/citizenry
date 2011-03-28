class ResourceLink < ActiveRecord::Base
  has_paper_trail
end


# == Schema Information
#
# Table name: resource_links
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  url         :string(255)
#  description :text
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

