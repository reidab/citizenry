require 'httparty'

namespace :calagator do
  desc "Update upcoming events count"
  task :update_count do
    events = HTTParty.get("http://calagator.org/events.json")
    if events && count = events.count
      File.open('tmp/calagator_events_count', 'w') {|f| f.write(count) }
    end
  end
end
