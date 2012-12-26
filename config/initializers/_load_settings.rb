# Load application settings from config/settings.yml
settings_yml = HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read(Rails.root.join('config', 'settings.yml'))).result))

merged_settings = settings_yml['common']
merged_settings.deep_merge!(settings_yml[Rails.env]) if settings_yml.has_key?(Rails.env)

SETTINGS = merged_settings
