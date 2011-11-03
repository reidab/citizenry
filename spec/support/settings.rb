module SettingsHelpers
  def with_settings(new_settings, &block)
    orig_settings = SETTINGS
    begin
      SETTINGS.deep_merge!(new_settings)
      block.call
    ensure
      silence_stderr { self.class.const_set(:SETTINGS, orig_settings) }
    end
  end
end

RSpec.configuration.include SettingsHelpers
