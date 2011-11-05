class Person < ActiveRecord::Base
  require 'open-uri'
  require 'digest/md5'

  include SearchEngine

  attr_protected :user_id
  has_paper_trail :ignore => [:user_id, :delta]
  acts_as_taggable_on :tags, :technologies
  sortable

  default_serialization_options :include => { :projects => {:include => [:tags, :technologies]}, 
                                              :groups => {:include => [:tags, :technologies]},
                                              :companies  => {:include => [:tags, :technologies]},
                                              :tags => {},
                                              :technologies => {}}

  import_image_from_url_as :photo, :gravatar => true

  customizable_slug_from :name

  belongs_to :user
  accepts_nested_attributes_for :user, :update_only => true

  has_many :project_memberships
  has_many :projects, :through => :project_memberships

  has_many :group_memberships
  has_many :groups, :through => :group_memberships

  has_many :employments
  has_many :companies, :through => :employments

  validates_presence_of :name

  before_save :attach_to_matching_user

  scope :claimed, where('user_id IS NOT null')
  scope :unclaimed, where('user_id IS null')

  private

  def matching_user
    @matching_user ||= Authentication.where( :provider => self.imported_from_provider,
                                             :uid => self.imported_from_id ).first.try(:user)
  end

  def attach_to_matching_user
    if self.user.nil? && matching_user.present?
      self.user = matching_user
    end
  end

  SAMPLE_PERSON = {
    :email => "sample@sample.org",
    :url => "http://sample.org/~sample",
    :twitter => "sample",
    :bio => "I am a sample person's profile.",
    :name => "Sample Person",
    :location => "Portland, Oregon",
    :reviewed => true,
  }

  def self.find_sample
    return self.where(:email => User::SAMPLE_USER[:email]).first
  end

  def self.find_or_create_sample(create_backreference=true)
    person = self.find_sample
    unless person
      person = self.create!(SAMPLE_PERSON)
    end
    if create_backreference && ! person.user
      User.find_or_create_sample(false)
      person.reload!
    end
    return person
  end

end






# == Schema Information
#
# Table name: people
#
#  id                        :integer(4)      not null, primary key
#  email                     :string(255)
#  twitter                   :string(255)
#  url                       :string(255)
#  bio                       :text
#  created_at                :datetime
#  updated_at                :datetime
#  user_id                   :integer(4)
#  name                      :string(255)
#  imported_from_provider    :string(255)
#  imported_from_id          :string(255)
#  location                  :string(255)
#  photo_file_name           :string(255)
#  photo_content_type        :string(255)
#  photo_file_size           :integer(4)
#  photo_updated_at          :datetime
#  reviewed                  :boolean(1)      default(FALSE)
#  imported_from_screen_name :string(255)
#  delta                     :boolean(1)      default(TRUE), not null
#

