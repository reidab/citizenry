require 'pathname'
$LOAD_PATH.unshift Pathname.new(__FILE__).dirname.join('..', 'lib').expand_path
require "moonshine/astrails_safe"

include Moonshine::AstrailsSafe