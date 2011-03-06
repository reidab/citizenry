class SiteController < ApplicationController
  def index
    page_title false

    events_count_path = 'tmp/calagator_events_count'
    if File.exists?(events_count_path)
      @events_count = File.read(events_count_path).to_i
    end
  end
end
