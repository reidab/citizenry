God.watch do |w|
  w.name = "<%= configuration[:application] %>-sphinx"

  w.interval = 30.seconds

  w.uid = '<%= configuration[:user] %>'
  w.gid = '<%= configuration[:user] %>'

  w.env = { 'RAILS_ENV' => RAILS_ENV }

  w.start         = "searchd --config <%= sphinx_configuration[:config_file] %>"
  w.start_grace   = 10.seconds
  w.stop          = "searchd --config <%= sphinx_configuration[:config_file] %> --stop"
  w.stop_grace    = 10.seconds
  w.restart       = w.stop + " && " + w.start
  w.restart_grace = 15.seconds

  w.log      = '<%= configuration[:deploy_to] %>/shared/log/searchd.god.log'
  w.pid_file = '<%= configuration[:deploy_to] %>/shared/log/searchd.pid'

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval  = 5.seconds
      c.running   = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
<% if configuration[:sphinx][:god] && configuration[:sphinx][:god][:restart_notify] %>
      c.notify = "<%= configuration[:sphinx][:god][:restart_notify] %>"
<% end %>
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state      = [:start, :restart]
      c.times         = 5
      c.within        = 5.minutes
      c.transition    = :unmonitored
      c.retry_in      = 10.minutes
      c.retry_times   = 5
      c.retry_within  = 2.hours
<% if configuration[:sphinx][:god] && configuration[:sphinx][:god][:flapping_notify] %>
      c.notify = "<%= configuration[:sphinx][:god][:flapping_notify] %>"
<% end %>
    end
  end
end
