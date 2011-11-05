# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
# Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
Citizenry::Application.config.time_zone = SETTINGS['timezone'] || 'Pacific Time (US & Canada)'

# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
Citizenry::Application.config.i18n.default_locale = SETTINGS['locale'] || 'en'
