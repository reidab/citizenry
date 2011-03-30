require 'rubygems'
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require File.join(File.dirname(__FILE__), '..', '..', 'moonshine', 'lib', 'moonshine.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'moonshine', 'god.rb')

require 'shadow_puppet/test'
require 'moonshine/matchers'

Spec::Runner.configure do |config|
  config.include Moonshine::Matchers
end
