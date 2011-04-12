class SiteController < ApplicationController
  respond_to :html, :xml, :json, :only => [:search]

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
      pagination_options = params[:page] == 'all' \
                            ? {:page => 1, :per_page => 9999999} \
                            : { :page => params[:page], :per_page => params[:per_page] || 30 }
      @results = SearchEngine.search(params[:query], {:match_mode => :extended}.merge(pagination_options))

      if request.format.html? && @results.length == 1
        flash[:notice] = "This is the one result we found when searching for <em>#{params[:query]}</em>. Enjoy!".html_safe
        redirect_to @results.first and return
      end

      respond_with(@results)
    end
  end
end
