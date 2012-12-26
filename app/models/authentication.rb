class Authentication < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :user
  serialize :info

  before_validation(:initialize_user_if_absent, :on => :create)
  after_save :attach_matching_person_to_user

  validates_presence_of :user

  scope :via, lambda{|provider| where(:provider => provider)}
  scope :searchable, where("provider = 'twitter' OR provider = 'facebook' OR provider = 'linked_in' OR provider = 'foursquare'")

  SETTINGS['providers'].each do |provider|
    scope "via_#{provider.to_sym}", where("provider = ?", provider)
  end

  def self.provider_options
    @provider_options ||= \
      [[I18n.t('authentication_method.choose_automatically'), 'auto']] \
        + SETTINGS['providers'].map{|provider|
            [OmniAuth::Utils.camelize(provider), provider]
          }
  end

  def api_client
    APIClient.for(self)
  end
  memoize :api_client

  def to_person
    if self.api_client
      if self.uid.present?
        api_client.get(self.uid)
      else
        Person.new
      end
    else
      Person.new(
          :name => self.info[:name],
          :location => self.info[:location],
          :bio => self.info[:description],
          :photo_import_url => self.info[:image],
          :url => self.info[:urls].try(:values).try(:first)
        )
    end
  end

  #--[ Updating information at auth-time ]-------------------------------------

  def update_from_omniauth(omniauth)
    extract_credentials_from_omniauth(omniauth)
    extract_info_from_omniauth(omniauth)
  end

  # See 1.0 https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema

  def extract_credentials_from_omniauth(omniauth)
    if omniauth.has_key?('credentials')
      self.access_token = omniauth['credentials']['token']
      self.access_token_secret = omniauth['credentials']['secret']
    end
  end

  # We only want to retain certain user info from omniauth responses, depending on the provider.
  # Favor 'extra > raw_info'. If none found, depend on 'info'
  def extract_info_from_omniauth(omniauth)
    if omniauth.has_key?('extra') && omniauth['extra'].has_key?('raw_info')
      self.info = omniauth['info'].merge(omniauth['extra']['raw_info']).symbolize_keys
    elsif omniauth.has_key?('info') # last resort
      self.info = omniauth['info'].symbolize_keys
    end
  end

  #--[ Building Authentications from OmniAuth responses ]----------------------

  def self.new_from_omniauth(omniauth, options={})
    new_user = options.delete(:new_user)
    options.reverse_merge!(:provider => omniauth['provider'], :uid => omniauth['uid'])

    auth = self.new(options)
    auth.update_from_omniauth(omniauth)

    auth.build_user(new_user) if new_user.present?

    auth
  end

  def self.create_from_omniauth(omniauth, options={})
    auth = self.new_from_omniauth(omniauth, options)
    auth if auth.save
  end

  def self.create_from_omniauth!(omniauth, options={})
    auth = self.new_from_omniauth(omniauth, options)
    auth if auth.save!
  end

  def initialize_user_if_absent
    self.build_user unless self.user.present?
  end

  def matching_person
    @matching_person ||= Person.where(:imported_from_provider => self.provider,
                                      :imported_from_id => self.uid).first
  end

  def attach_matching_person_to_user
    if self.user && self.user.person.nil? && matching_person.present?
      matching_person.update_attribute(:user_id, self.user_id)
    end
  end
end



# == Schema Information
#
# Table name: authentications
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  provider            :string(255)
#  uid                 :string(255)
#  access_token        :string(255)
#  access_token_secret :string(255)
#  info                :text
#  created_at          :datetime
#  updated_at          :datetime
#

