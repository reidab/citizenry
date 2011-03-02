server 'epdx', :app, :web, :db, :primary => true

require 'config/boot'
require 'hoptoad_notifier/capistrano'
