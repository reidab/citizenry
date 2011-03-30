class Person < ActiveRecord::Base
  require 'open-uri'
  require 'digest/md5'

  include SearchEngine

  attr_protected :user_id
  has_paper_trail :ignore => [:user_id]
  acts_as_taggable_on :tags, :technologies
  sortable

  default_json_options :include => [:projects, :groups, :companies]

  has_attached_file :photo, :styles => { :medium => '220x220#', :thumb => '48x48#' }, :url => "/system/:attachment/:id/:style/:safe_filename"
  PHOTO_SIZES = {:medium => 220, :thumb => 48} # for gravatar

  attr_accessor :photo_import_url
  before_validation do
    if self.photo_import_url.present?
      io = open(URI.parse(self.photo_import_url))
      def io.original_filename; base_uri.path.split('/').last; end

      self.photo = io if io.original_filename.present?
    end
  end

  belongs_to :user

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

  define_index do
    indexes :name, :sortable => true
    indexes :bio
    indexes :url
    indexes :location
    indexes technology_taggings.tag.name, :as => :technologies
    indexes tag_taggings.tag.name, :as => :tags

    has :created_at, :updated_at
  end

  # returns a photo url, with fallback to a unique-within-epdx generated avatar from gravatar
  def photo_url(size)
    size ||= :medium
    self.photo.file? ? self.photo.url(size) : "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.id.to_s)}?d=retro&f=y&s=#{PHOTO_SIZES[size]}"
  end

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
#

