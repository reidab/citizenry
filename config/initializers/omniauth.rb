require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  SETTINGS['auth_credentials'].each do |provider_name, opts|
    provider  provider_name.to_sym, opts['key'], opts['secret']
  end

  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
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
