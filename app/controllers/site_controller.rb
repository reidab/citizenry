class SiteController < ApplicationController
  def index
    page_title false

    events_count_path = 'tmp/calagator_events_count'
    if File.exists?(events_count_path)
      @events_count = File.read(events_count_path).to_i
    end
  end

  def search
    redirect_to search_path(:query => params[:q]) and return if params[:q].present?

    if params[:query]
      @results = SearchEngine.search(params[:query],
                                     :match_mode => :extended,
                                     :page => params[:page],
                                     :per_page => params[:per_page] || 30)
    end
  end
end
