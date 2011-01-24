# Load application settings from config/settings.yml
settings_yml = YAML.load_file(Rails.root.join('config', 'settings.yml'))

merged_settings = settings_yml['common']
merged_settings.deep_merge!(settings_yml[Rails.env]) if settings_yml.has_key?(Rails.env)

SETTINGS = merged_settings