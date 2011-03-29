$: << File.dirname(__FILE__) + '/../lib'
 
require 'rubygems'
require 'spec'
require 'active_record'
require 'action_controller'
require 'active_support'
require 'action_view'
require 'hey_sorty'

include ActionView::Helpers::UrlHelper
include ActionController::UrlWriter

# Setup test database file
test_database = File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
File.unlink(test_database) if File.exist?(test_database)
ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => test_database)
 
# Load schema
ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load(File.join(File.dirname(__FILE__), 'schema.rb'))
end

# Models
class User < ActiveRecord::Base
  has_many :sortables
end

class Sortable < ActiveRecord::Base
  belongs_to :user
  sortable
end

class Unsortable < ActiveRecord::Base
end

# When running specs in TextMate, provide an rputs method to cleanly print objects into HTML display
# From http://talklikeaduck.denhaven2.com/2009/09/23/rspec-textmate-pro-tip
module Kernel
  if ENV.keys.find {|env_var| env_var.match(/^TM_/)}
    def rputs(*args)
      puts( *["<pre>", args.collect {|a| CGI.escapeHTML(a.to_s)}, "</pre>"])
    end
  else
    alias_method :rputs, :puts
  end
end