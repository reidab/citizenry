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

  has_attached_file :photo, :styles => { :medium => '220x220#', :thumb => '48x48#' }, :url => "/system/:attachment/:id/:style/:safe_filename"
  PHOTO_SIZES = {:medium => 220, :thumb => 48} # for gravatar
  MAX_PHOTO_BYTES = 500.kilobytes
  PHOTO_TIMEOUT_SECONDS = 10
  validates_attachment_size :photo, :less_than => MAX_PHOTO_BYTES
  # TODO Add content_type validation. The trouble is that PaperClip thinks the content_type of an uploaded image is always "text/html; charset=iso-8859-1" and ignores any attempt to override it.
  ### validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg', 'image/x-png']

  # Import photo on validation if available from this accessor
  attr_accessor :photo_import_url
  validate :import_photo, :if => "photo_import_url.present?"

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

  # Import photo if URL is provided and report errors.
  def import_photo
    if self.photo_import_url.present?
      # Normalize
      url = self.photo_import_url.downcase
      url = "http://#{url}" unless url.include?("http")

      # Validate URL
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError
        self.errors.add(:photo_import_url, "Invalid photo URL")
        return false
      end

      # Download
      io = nil
      begin
        Timeout::timeout(PHOTO_TIMEOUT_SECONDS) do
          io = uri.open
        end
      rescue OpenURI::HTTPError => e
        self.errors.add(:photo_import_url, "Unable to import photo URL: #{e}")
        return false
      rescue Timeout::Error => e
        self.errors.add(:photo_import_url, "Unable to import photo URL, timed-out after #{PHOTO_TIMEOUT_SECONDS} seconds")
        return false
      end

      # Validate status
      unless io.status.first.to_i == 200
        self.errors.add(:photo_import_url, "Unable to import photo URL: HTTP status code #{io.status.first} -- #{io.status.last}")
        return false
      end

      # Validate size
      if io.size == 0
        self.errors.add(:photo_import_url, "Couldn't import photo from URL, file size is 0 bytes")
        return false
      elsif io.size > MAX_PHOTO_BYTES
        self.errors.add(:photo_import_url, "Couldn't import photo from URL, size must be smaller than #{MAX_PHOTO_BYTES} bytes, but was #{io.size} bytes")
        return false
      end

      # Provide a way to get the filename from the 'open-uri' result
      def io.original_filename; base_uri.path.split('/').last; end

      self.photo = io
      return true
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
#  delta                     :boolean(1)      default(TRUE), not null
#

