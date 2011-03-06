source 'http://rubygems.org'

gem 'rails', '3.0.5'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql'

gem 'hoptoad_notifier'

#--[ Utility ]------------------------------------------------------------------
gem 'httparty', '~> 0.7.4'
gem "json", "~> 1.4.6"
gem 'addressable', '~> 2.2.4'

#--[ Authentication ]-----------------------------------------------------------
gem 'devise', "~> 1.1.5"
gem 'omniauth', "~> 0.2.0"

# Automatic login provider selection
gem 'redfinger', '~> 0.1.0', :git => "https://github.com/reidab/redfinger.git"
gem 'ruby-openid', '~> 2.1.8'
gem 'net-dns', '~> 0.6.1', :require => 'net/dns/resolver'

# Client libraries for authenticated services
gem 'twitter', '~> 1.1.1'
gem 'linkedin', '~> 0.1.7', :git => "https://github.com/pengwynn/linkedin.git"
gem 'mogli', '~>0.0.25', :git => "https://github.com/reidab/mogli.git" # facebook
gem 'foursquare2', '~>0.9.0'   # https://gist.github.com/419219 <- github oauth docs!

#--[ Model ]--------------------------------------------------------------------
gem "paperclip", "~> 2.3"
gem "inherited_resources", "~> 1.2.1"
gem "responders", "~> 0.6.2"

gem 'acts-as-taggable-on', "~> 2.0.6"
gem 'will_paginate', '~> 3.0.pre2'

gem 'paper_trail', '~> 2'
gem 'paper_trail_manager', :git => 'https://github.com/reidab/paper_trail_manager.git'
# gem 'paper_trail_manager', :path => '../paper_trail_manager'

#--[ View ]---------------------------------------------------------------------
gem "haml", "~> 3.0.18"
gem "compass", "~> 0.10.5"
gem "compass-960-plugin", "~> 0.9.13", :require => 'ninesixty'
gem 'jquery-rails', '>= 0.2.6'
gem 'formtastic', '~>1.1.0'

#--[ Controller ]---------------------------------------------------------------
gem 'will_paginate', '~> 3.0.pre2'


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # -- [ Testing ] -------------------------------------------------------------
  gem 'rspec-rails', '>= 2.0.0.beta.22'
  gem "mocha"
  gem "fakeweb"
  gem "factory_girl_rails"
  gem 'faker'
  gem 'uuid'
  gem 'steak'
  gem 'capybara'
  gem 'capybara-envjs'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'faker'
  gem 'spork'

  # -- [ IRB ] -----------------------------------------------------------------
  gem 'awesome_print'
  gem 'drx'
  gem 'wirble'
  gem 'utility_belt'

  # -- [ Tools ] ---------------------------------------------------------------
  gem 'rcov'
  gem 'ruby-debug'
  gem 'annotate'
  gem "nifty-generators"
end
