require 'openid'
require 'openid/store/filesystem'

OpenID.fetcher.timeout = 6

Rails.application.config.middleware.use OmniAuth::Builder do
  ssl_client_options = {}

  if SETTINGS['ssl_ca_path'].present?
    ssl_client_options = {:client_options => {:ssl => {:ca_path => SETTINGS['ssl_ca_path']}}}
  end

  SETTINGS['auth_credentials'].each do |provider_name, opts|
    provider(provider_name.to_sym, opts['key'], opts['secret'], ssl_client_options)
  end

  provider(:open_id, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'open_id') if SETTINGS['providers'].include?('open_id')

  if SETTINGS['providers'].include?('google')
    provider(:open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id')
  end

  if SETTINGS['providers'].include?('yahoo')
    provider(:open_id, :name => 'yahoo', :identifier => 'yahoo.com')
  end
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
