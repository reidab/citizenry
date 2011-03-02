unless SETTINGS['hoptoad'] == 'seekrit!'
  HoptoadNotifier.configure do |config|
    config.api_key = SETTINGS['hoptoad']
  end
end
