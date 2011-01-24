Rails.application.config.middleware.use OmniAuth::Builder do
  SETTINGS['auth_credentials'].each do |provider_name, opts|
    provider  provider_name.to_sym, opts['key'], opts['secret']
  end
end