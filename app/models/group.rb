class Group < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => '250x250', :thumb => '48x48' }

  has_and_belongs_to_many :projects

  has_many :group_memberships
  has_many :people, :through => :group_memberships

  has_many :sponsorships
  has_many :companies, :through => :sponsorships

  validates_presence_of :name

  def self.from_twitter(screen_name, twitter_token)
    twitterer = twitter_token.get("/users/show?screen_name=#{screen_name}")

    return self.new(
      :twitter => screen_name,
      :name => twitterer['name'],
      :description => twitterer['description'],
      :url => twitterer['url'],
      :logo_url => twitterer['profile_image_url']
    )
  end
end



# == Schema Information
#
# Table name: groups
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  description       :text
#  url               :string(255)
#  mailing_list      :string(255)
#  twitter           :string(255)
#  meeting_info      :text
#  created_at        :datetime
#  updated_at        :datetime
#  logo_url          :string(255)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

