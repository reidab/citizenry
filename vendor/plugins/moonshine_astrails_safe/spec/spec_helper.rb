require 'rubygems'
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'moonshine', 'lib')
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'moonshine'
require 'moonshine/astrails_safe'
require 'shadow_puppet/test'