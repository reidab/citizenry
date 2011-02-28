class Person < ActiveRecord::Base
  require 'open-uri'
  has_attached_file :photo, :styles => { :medium => '220x220', :thumb => '48x48#' }

  attr_accessor :photo_import_url
  before_validation do
    if self.photo_import_url.present?
      io = open(URI.parse(self.photo_import_url))
      def io.original_filename; base_uri.path.split('/').last; end

      self.photo = io if io.original_filename.present?
    end
  end

  belongs_to :user

  has_and_belongs_to_many :projects

  has_many :group_memberships
  has_many :groups, :through => :group_memberships

  has_many :employments
  has_many :companies, :through => :employments

  validates_presence_of :name

end




# == Schema Information
#
# Table name: people
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)
#  twitter                :string(255)
#  url                    :string(255)
#  bio                    :text
#  created_at             :datetime
#  updated_at             :datetime
#  user_id                :integer(4)
#  name                   :string(255)
#  imported_from_provider :string(255)
#  imported_from_id       :string(255)
#  location               :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer(4)
#  photo_updated_at       :datetime
#

