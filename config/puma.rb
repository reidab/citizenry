rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  "unix:///data/apps/epdx/shared/tmp/puma/appname-puma.sock"
pidfile      "/data/apps/epdx/current/tmp/puma/pid"
state_path   "/data/apps/epdx/current/tmp/puma/state"

activate_control_app
