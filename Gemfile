source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rake', :require => false
gem 'rails-i18n'

# You may need to add the following to your .bash_profile (or
# similar):
#
#     export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
#
# Note: the exact path to your MySQL lib/ directory may vary.
gem 'mysql2', '~> 0.3.2'
# Uncomment if you're using sqlite
# gem 'sqlite3-ruby', :require => 'sqlite3'


gem 'hoptoad_notifier'

#--[ Utility ]------------------------------------------------------------------
gem 'httparty', '~> 0.7.4'
gem "json", "~> 1.6.1"
gem 'addressable', '~> 2.2.6'

#--[ Authentication ]-----------------------------------------------------------
gem 'devise', "~> 1.4.5"

gem 'omniauth', "~> 1.0.3"
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-foursquare'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-yahoo'
gem 'omniauth-viadeo'

# Automatic login provider selection
gem 'redfinger', '~> 0.1.0'
gem 'ruby-openid', '~> 2.1.8'
gem 'net-dns', '~> 0.6.1', :require => 'net/dns/resolver'


#--[ Search ]-------------------------------------------------------------------
# If you're using the default sql-based search, you can comment this out.
#gem 'thinking-sphinx', '~> 2.0.1', :require => 'thinking_sphinx'

#--[ Model ]--------------------------------------------------------------------
gem "paperclip", "~> 2.3"
gem "inherited_resources", "~> 1.3.0"
gem "responders", "~> 0.6.2"

gem 'acts-as-taggable-on', "~> 2.1.1"

gem 'friendly_id', '4.0.0.beta14'

gem 'paper_trail', '~> 2'
gem 'paper_trail_manager', '~> 0.1.3'
# gem 'paper_trail_manager', :path => '../paper_trail_manager'

#--[ View ]---------------------------------------------------------------------
gem "haml", "~> 3.1.2"
gem "sass", "~> 3.1.4"
gem "compass", "~> 0.11.5"
gem "compass-960-plugin", "~> 0.10.4", :require => 'ninesixty'
gem 'jquery-rails', '>= 1.0.14'
gem 'formtastic', '~>1.2.4'

#--[ Controller ]---------------------------------------------------------------
gem 'will_paginate', '~> 3.0.2'

#--[ Middleware ]---------------------------------------------------------------
gem 'rack-jsonp', '~> 1.2.0'


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # -- [ IRB ] -----------------------------------------------------------------
  gem 'awesome_print'
  gem 'drx'
  gem 'wirble'
  gem 'utility_belt'

  # -- [ Tools ] ---------------------------------------------------------------
  gem 'simplecov', :require => false
  gem 'ruby-debug19'
  gem 'annotate'
  gem "nifty-generators"
end


gem 'rspec-rails', '>= 2.6.0'
group :test do
  # -- [ Testing ] -------------------------------------------------------------
  gem "mocha"
  gem "fakeweb"
  gem "factory_girl_rails"
  gem 'faker', '>= 1.0'
	gem "systemu", "~> 2.4.0"
	gem "uuid", "~> 2.3.4"
  gem 'steak', '1.1.0'
  gem 'capybara', '~> 0.4.0'
  # gem 'capybara-envjs'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'spork'
end
