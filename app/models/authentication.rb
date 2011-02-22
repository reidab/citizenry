class Authentication < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :user
  serialize :info

  before_validation_on_create :initialize_user_if_absent
  validates_presence_of :user

  SETTINGS['providers'].each do |provider|
    scope "via_#{provider.to_sym}", where("provider = ?", provider)
  end

  PROVIDER_OPTIONS = [["Choose automatically", 'auto']] \
                        + SETTINGS['providers'].map{|provider|
                            [OmniAuth::Utils.camelize(provider), provider]
                          }

  def oauth_token
    consumer = OAUTH_CONSUMERS[provider]

    if consumer.is_a?(OAuth::Consumer)
      OAuth::AccessToken.new(consumer, access_token, access_token_secret)
    elsif consumer.is_a?(OAuth2::Client)
      OAuth2::AccessToken.new(consumer, access_token)
    else
      nil
    end
  end
  memoize :oauth_token

  def client
    case self.provider.to_sym
    when :twitter
      Twitter.client(:consumer_key => SETTINGS['auth_credentials']['twitter']['key'],
                     :consumer_secret => SETTINGS['auth_credentials']['twitter']['secret'],
                     :oauth_token => self.access_token,
                     :oauth_token_secret => self.access_token_secret)
    when :facebook
      Mogli::Client.new(self.access_token)
    when :linked_in
      li_client = LinkedIn::Client.new( SETTINGS['auth_credentials']['linked_in']['key'],
                                        SETTINGS['auth_credentials']['linked_in']['secret'] )
      li_client.authorize_from_access(self.access_token, self.access_token_secret)

      li_client
    when :foursquare
      fs_auth = Foursquare::OAuth.new(SETTINGS['auth_credentials']['foursquare']['key'],
                                        SETTINGS['auth_credentials']['foursquare']['secret'] )
      fs_auth.authorize_from_access(self.access_token, self.access_token_secret)

      Foursquare::Base.new(fs_auth)
    else
      self.oauth_token
    end
  end
  memoize :client

  #--[ Updating information at auth-time ]-------------------------------------

  def update_from_omniauth(omniauth)
    extract_credentials_from_omniauth(omniauth)
    extract_info_from_omniauth(omniauth)
  end

  def extract_credentials_from_omniauth(omniauth)
    if omniauth.has_key?('credentials')
      self.access_token = omniauth['credentials']['token']
      self.access_token_secret = omniauth['credentials']['secret']
    end
  end

  # We only want to retain certain user info from omniauth responses, depending on the provider.
  def extract_info_from_omniauth(omniauth)
    if omniauth.has_key?('extra') && omniauth['extra'].has_key?('user_hash')
      self.info = omniauth['user_info'].merge(omniauth['extra']['user_hash'])
    else
      self.info = omniauth['user_info']
    end
  end

  #--[ Building Authentications from OmniAuth responses ]----------------------

  def self.new_from_omniauth(omniauth, options={})
    options.reverse_merge!(:provider => omniauth['provider'], :uid => omniauth['uid'])

    auth = self.new(options)
    auth.update_from_omniauth(omniauth)

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
end


# == Schema Information
#
# Table name: authentications
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  provider            :string(255)
#  uid                 :string(255)
#  info                :text
#  created_at          :datetime
#  updated_at          :datetime
#  access_token        :string(255)
#  access_token_secret :string(255)
#

