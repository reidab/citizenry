class ResourceLinksController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @resource_links = ResourceLink.all.group_by(&:category)
  end

  def show
    show! do |format|
      format.html { redirect_to resource_links_path(:anchor => params[:id]) }
    end
  end
end
