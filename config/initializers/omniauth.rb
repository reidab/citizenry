require 'openid'
require 'openid/store/filesystem'

OpenID.fetcher.timeout = 6

Rails.application.config.middleware.use OmniAuth::Builder do
  SETTINGS['auth_credentials'].each do |provider_name, opts|
    provider  provider_name.to_sym, opts['key'], opts['secret']
  end



  provider(:open_id, OpenID::Store::Filesystem.new('/tmp')) if SETTINGS['providers'].include?('open_id')

  use(OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'),
      :name => 'yahoo',
      :identifier => 'yahoo.com') \
      if SETTINGS['providers'].include?('yahoo')

  use(OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'),
      :name => 'google',
      :identifier => 'https://www.google.com/accounts/o8/id') \
      if SETTINGS['providers'].include?('google')

  provider :google_apps, OpenID::Store::Filesystem.new('/tmp')
end



consumers = {}
SETTINGS['auth_credentials'].each do |provider_name, opts|
  strategy_class = OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(provider_name)}")
  strategy = strategy_class.new(nil, opts['key'], opts['secret'])

  if strategy.is_a?(OmniAuth::Strategies::OAuth)
    consumers[provider_name] = strategy.consumer
  elsif strategy.is_a?(OmniAuth::Strategies::OAuth2)
    consumers[provider_name] = strategy.client
  end
end

OAUTH_CONSUMERS = consumers
