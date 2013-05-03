rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  "unix:///u/apps/epdx/shared/tmp/puma/epdx-puma.sock"
pidfile      "/u/apps/epdx/current/tmp/puma/pid"
state_path   "/u/apps/epdx/current/tmp/puma/state"

activate_control_app
