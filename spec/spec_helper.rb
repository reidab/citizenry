# Enable SimpleCov-based coverage when run through `rake simplecov` or `COVERAGE=1 rspec spec/models/person_spec.rb`. This really does need to be at the top of this file
if ENV['COVERAGE']
  begin
    require 'simplecov'
    SimpleCov.start('rails')
  rescue LoadError
    puts "COVERAGE: Can't require 'simplecov'. If you're on Ruby 1.8, use `rake spec:rcov` instead."
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  require 'fakeweb'
  FakeWeb.allow_net_connect = false
  require 'faker'
  Faker::Config.locale = :en
end
