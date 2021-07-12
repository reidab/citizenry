source "http://rubygems.org"

gem "rails", "~> 3.2.11"
gem "rails-i18n"

# You may need to add the following to your .bash_profile (or
# similar):
#
#     export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
#
# Note: the exact path to your MySQL lib/ directory may vary.
gem "mysql2", "~> 0.3.15"
# Uncomment if you"re using sqlite
# gem "sqlite3-ruby", :require => "sqlite3"

group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">=1.0.3"
  gem 'compass-rails'
end

gem "hoptoad_notifier"

#--[ Utility ]------------------------------------------------------------------
gem "httparty", "~> 0.8.0"
gem "json", "~> 1.6.1"
gem "addressable", "2.8.0", :require => 'addressable/uri'

#--[ Authentication ]-----------------------------------------------------------
gem "devise", "~> 1.4.5"
gem "omniauth", "~> 1.1"

# Automatic login provider selection
gem "redfinger", "~> 0.1.0", :git => "git://github.com/reidab/redfinger.git"
gem "ruby-openid", "~> 2.1.8"
gem "net-dns", "~> 0.6.1", :require => "net/dns/resolver"

# Client libraries for authenticated services
gem "omniauth-github"
gem "omniauth-openid"
gem "omniauth-twitter"
gem "omniauth-linkedin"
gem "omniauth-facebook"
gem "omniauth-foursquare", "~> 1.0.1"
# TODO: Switch to using OAuth for Google and Yahoo sign-in
# gem "omniauth-google-apps"
# gem "omniauth-yahoo"
#
gem 'mogli'

#--[ Search ]-------------------------------------------------------------------
# If you"re using the default sql-based search, you can comment this out.
gem "thinking-sphinx", "~> 3.1.0"

#--[ Model ]--------------------------------------------------------------------
gem "paperclip", "~> 2.3"
gem "inherited_resources", "1.3.1"

gem "acts-as-taggable-on", "~> 2.1.1"

gem "friendly_id", "4.0.9"

gem "paper_trail", "~> 2"
gem "paper_trail_manager"
# gem "paper_trail_manager", :git => "git://github.com/igal/paper_trail_manager.git"
# gem "paper_trail_manager", :path => "../paper_trail_manager"

#--[ View ]---------------------------------------------------------------------
gem "haml", "~> 3.1.2"
gem "sass", "~> 3.1.4"
gem "compass-960-plugin", "~> 0.10.4", :require => "ninesixty"
gem "jquery-rails", ">= 1.0.14"
gem "formtastic", "2.2.1"

#--[ Controller ]---------------------------------------------------------------
gem "will_paginate", "~> 3.0.1"

#--[ Middleware ]---------------------------------------------------------------
gem "rack-jsonp", "~> 1.2.0"


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # -- [ Tools ] ---------------------------------------------------------------
  gem "simplecov", :require => false
  gem "nifty-generators"
  gem "rspec-rails", ">= 2.6.0"
end

group :test do
  # -- [ Testing ] -------------------------------------------------------------
  gem "fakeweb"
  gem "factory_girl_rails"
  gem "faker", ">= 1.0"
  gem "uuid"
  gem "steak", "2.0.0"
  gem "capybara", "~> 1.1.1"
  # gem "capybara-envjs"
  gem "launchy"
  gem "database_cleaner"
  gem "spork"
end
