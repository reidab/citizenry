require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"
# require 'capybara/envjs'
# Capybara.javascript_driver = :envjs

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

require 'fakeweb'
FakeWeb.allow_net_connect = false

RSpec.configure do |c|
  c.use_transactional_fixtures = false
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
