class SiteController < ApplicationController
  before_filter :login_required, :only => :index

  def index
    
  end
end
