class Person < ActiveRecord::Base
  has_attached_file :photo, :styles => { :medium => '250x250', :thumb => '48x48' }

  belongs_to :user

  has_and_belongs_to_many :projects

  has_many :group_memberships
  has_many :groups, :through => :group_memberships

  has_many :employments
  has_many :companies, :through => :employments

  validates_presence_of :name

  def self.from_user(user)
    first_name, last_name = user.name.split(/\s+/, 2)

    return  self.new(
              :twitter => user.login,
              :first_name => first_name,
              :last_name => last_name,
              :bio => user.description,
              :url => user.url,
              :avatar_url => user.profile_image_url
            )
  end

  def self.from_twitter(screen_name, twitter_token)
    twitterer = twitter_token.get("/users/show?screen_name=#{screen_name}")
    first_name, last_name = twitterer['name'].split(/\s+/, 2)

    return self.new(
      :twitter => screen_name,
      :first_name => first_name,
      :last_name => last_name,
      :bio => twitterer['description'],
      :url => twitterer['url'],
      :avatar_url => twitterer['profile_image_url']
    )
  end
end



# == Schema Information
#
# Table name: people
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  twitter    :string(255)
#  url        :string(255)
#  bio        :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer(4)
#  avatar_url :string(255)
#  name       :string(255)
#

